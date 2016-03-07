#!/usr/bin/perl
use strict;
use warnings;
use JSON::XS;
use Data::Dumper;
use Getopt::Std;

my %opts;
getopt('f:m:', \%opts);
# TODO try and figure out how to select the last focused window

if (defined $opts{f}) {
  # Focus the ith window
  my $i = $opts{f};
  my $cur = get_current_workspace();
  my $ws = filter(undef, num => $cur->{num});
  return 1 unless scalar(@$ws);
  my $win = filter($ws->[0], nodes => []);
  $i = scalar(@$win) - 1 if scalar(@$win) <= $i;
  focus(con_id => $win->[$i]->{id});
} elsif (defined $opts{m}) {
  # Mark the current window with m, then focus the old m
  my $m = $opts{m};
  my $cur = get_current_workspace();
  #my $ws = filter(undef, num => $cur->{num});
  #return 1 unless scalar(@$ws);
  my $win = filter(undef, mark => $m);
  return 1 unless scalar(@$win);
  $win = $win->[0]; # Get the 0th window
  `i3-msg mark $m`; # TODO make this use cmd
  focus(con_id => $win->{id});
}

#############################################################################################################
# I3 Functions
# TODO use the unix socket: i3 --get-socketpath

# Sends a basic message to i3 $cmd is one of {get_workspaces, get_outputs, get_tree, get_marks, get_bar_config}
sub msg {
  my ($cmd) = @_;
  my $d = `i3-msg -t $cmd`;
  return decode_json($d);
}

# Sends the given $cmd with the given $args.
sub cmd {
  my ($cmd, %args) = @_;
  # TODO this won't work for e.g. focus left
  my $a = join(' ', map {"$_=\"$args{$_}\""} keys %args);
  #print "Sending: ([$a] $cmd)\n";
  return `i3-msg [$a] $cmd`;
}

# Focus the given window specified by the arguments (e.g. con_id=$id, or con_mark=$mark)
sub focus {
  my (%args) = @_;
  return cmd('focus', %args);
}

# Gets all the workspaced
# %cond is the conditions to filter on
sub get_workspaces {
  my (%cond) = @_;
  my @k = keys %cond;
  my $ws = msg('get_workspaces');
  my $r = [];
  for my $w(@$ws) {
    my $m = 1;
    for my $k(@k) {
      if ($w->{$k} ne $cond{$k}) {
        $m = 0;
        last;
      }
    }
    push(@$r, $w) if $m;
  }
  return $r;
}

# Gets the currently focused workspace.  $return->{num} is the number
sub get_current_workspace {
  my $a = get_workspaces('focused' => 1);
  return $a->[0];
}

# Returns all winows matching the given criteron
# $tree is the return from a prior filter, or undef to query i3-msg
# %cond is the set of key => value pairs to filter on.
# example to get all windows on the workspace numbered 1 filter(undef, num => 1)
# example to get all windows filter(undef, nodes => [])
# example to get all urgent windows (enclosed in their workspace) filter(undef, urgent => 1)
sub filter {
  my ($tree, %cond) = @_;
  my @k = keys %cond;
  if (!defined $tree) {
    #print "Initialized tree\n";
    $tree = msg('get_tree');
  }
  elsif (ref($tree) eq 'ARRAY') {
    #print "Reusing tree\n";
    $tree = {'list' => $tree};
  }
  #TODO filter?
  my $m = 1;
  for my $k(@k) {
    #print "Checking $k: $tree->{$k} == $cond{$k}\n";
    if (!$tree->{$k} || !compare($tree->{$k}, $cond{$k})) {
      #print "$tree->{$k} doesn't match\n";
      $m = 0;
      last;
    }
  }
  if ($m) { return [$tree]; }
  my $matches = [];
  for my $nodes ('nodes', 'floating_nodes', 'list') {
    if ($tree->{$nodes}) {
      #print "Checking $nodes\n";
      for my $node(@{$tree->{$nodes}}) {
        #print "Recursing\n";
        push(@$matches, @{filter($node, %cond)});
      }
    }
  }
  return $matches;
}

# A generic compare that will handle array refs or strings
sub compare {
  my ($a, $b) = @_;
  if (ref($a) eq 'ARRAY') {
    #print "Comparing arrays [@$a]==[@$b]\n";
    return 0 unless scalar(@$a) == scalar(@$b);
    #print "Comparing internally\n";
    my $r = 1;
    my %y = map {$_ => 1} @$b;
    for my $x(@$a) {
      unless ($y{$x}) {
        $r = 0;
        last;
      }
    }
    return $r;
  } else {
    return $a eq $b;
  }
}
