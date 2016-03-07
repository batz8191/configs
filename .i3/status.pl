#!/usr/bin/perl
use strict;
use IO::Select;
use POSIX qw(strftime);
use Time::HiRes qw(usleep);

my $LOW_BATT = 20;
my $LOW_BATT_COLOR = '#ffff00';
my $HIGH_CPU = 90;
my $HIGH_CPU_COLOR = '#ffffcc';
my $DATE_COLOR = '#ff8700';

my $CPU_FMT = '⚡ %2d%%';
my $VOL_FMT = '♬ %2d%%';
my $BATT_FMT = '%s %2d%%';
my $KEYBOARD_FMT = '⌨ %s';
my $UPDATES_FMT = '⌘ %d';
my $BATT_FMT = '%s %02d%%';
my $DATE_FMT = '%w %m/%d %I:%M %p';

my $i = 0;
my %order = map {$_ => $i++} qw(vol keyboard cpu updates batt date);

my %waits = (
	cpu => 1,
	batt => 5,
	vol => 1,
	date => 5,
	keyboard => 5,
	updates => 300,
);

print "{\"version\":1}\n[\n";

my $c = -1;
my @vals = (0) x 6;
my $b = 0;
while(1) {
	++$c;
	$c = 0 if $c > 100000;
	if (($c % $waits{vol}) == 0) { $vals[$order{vol}] = get_vol('Master'); }
	if (($c % $waits{keyboard}) == 0) { $vals[$order{keyboard}] = get_keyboard(); }
	if (($c % $waits{cpu}) == 0) { $vals[$order{cpu}] = get_cpu(); }
	if (($c % $waits{updates}) == 0) { $vals[$order{updates}] = get_updates(); }
	if (($c % $waits{batt}) == 0) { $vals[$order{batt}] = get_batt(); }
	if (($c % $waits{date}) == 0) { $vals[$order{date}] = get_date(); }
	if ($b) { print ','; }
	print "[", join(',', @vals), "]\n";
	$b = 1;
	usleep 1000000;
}

sub get_keyboard {
	my $r = `setxkbmap -print`;
	return color('keyboard', sprintf($KEYBOARD_FMT, $r =~ m/dvorak/ ? 'DV' : 'US'));
}

sub get_updates {
	return color('updates', sprintf($UPDATES_FMT, scalar(grep {/^Inst/} split(/\n/, `apt-get -s upgrade`))));
}

sub get_batt {
	my $b = `acpi -b`;
	$b =~ m/Battery\s+\d:\s+(\w+),\s+(\d+)%/;
	my $state = $1 eq 'Full' ? '⏚' : $1 eq 'Discharging' ? '⍊' : $1 eq 'Charging' ? '⍑' : 'U';
	my $batt = $2;
	my $color = $batt <= $LOW_BATT ? $LOW_BATT_COLOR : '';
	return color('battery', sprintf($BATT_FMT, $state, $batt), $color);
}

sub get_vol {
	my ($s) = @_;
	my $m = `amixer get $s`;
	$m =~ m/\[(\d+)%\]/;
	return color('volume', sprintf($VOL_FMT, $1));
}

sub get_date {
	return color('date', strftime($DATE_FMT, localtime), $DATE_COLOR);
}

my ($old_user, $old_sys, $old_idle, $old_iowait) = (0) x 5;
sub get_cpu {
	my $CPU;
	if (!open($CPU, '<', '/proc/stat')) {
		return color('cpu', sprintf($CPU_FMT, 0));
	}
	my $r = 0;
	while(<$CPU>) {
		if(m/cpu\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)/i) {
			my ($new_user, $unice, $new_sys, $new_idle, $new_iowait) = ($1, $2, $3, $4, $5);
			$new_user += $unice;
			my $user = $new_user - $old_user;
			my $sys = $new_sys - $old_sys;
			my $idle = $new_idle - $old_idle;
			my $iowait = $new_iowait - $old_iowait;
			my $max = $user + $sys + $idle + $iowait;
			my $val = $user + $sys + $iowait;
			($old_user, $old_sys, $old_idle, $old_iowait) = ($new_user, $new_sys, $new_idle, $new_iowait);
			$r = $max ? $val / $max * 100 : 0;
			last;
		}
	}
	close($CPU);
	my $color = $r >= $HIGH_CPU ? $HIGH_CPU_COLOR : '';
	return color('cpu', sprintf($CPU_FMT, $r), $color);
}

sub color {
	my ($name, $txt, $color, $urgent) = @_;
	my $s = "{\"name\":\"$name\",\"full_text\":\"$txt\"";
	$s .= ",\"color\":\"$color\"" if $color;
	$s .= ",\"urgent\":\"true\"" if $urgent;
	$s .= "}";
}
