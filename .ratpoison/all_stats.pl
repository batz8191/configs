#!/usr/bin/perl
use strict;
use IO::Socket;
use POSIX qw(strftime SIGINT);

my @p = split /\n/, `pgrep all_stats.pl`;
foreach my $p(@p) {
	if ($p != $$) {
		#print "Killing $p\n";
		kill SIGINT, - getpgrp($p);
		exit;
	}
}

my $d = strftime "%a %m/%d/%Y", localtime;
my $t = strftime "%I:%M%p", localtime;
#my @b = batt();
my $mv = vol('Master');
my $pv = vol('PCM');

my $font = '-*-Inconsolata-medium-r-normal-*-24-*-*-*-*-*-*-*';
my $lfont = '-*-Inconsolata-medium-r-normal-*-70-*-*-*-*-*-*-*';
open(DZEN, "|$ENV{HOME}/temp/dzen/dzen2 -fn '$font' -bg black -fg yellow -x 860 -y 440 -h 44 -w 220 -l 4 -ta c -sa l -p 60 -e 'onstart=uncollapse;button3=exit'") or die $!;

printf DZEN "^fn($lfont)^fg(orange)$t^fg()^fn()\n"
	. "^p(_CENTER)^p(-90)$d^p()\n"
	. "Master %9d\n"
	. "PCM %12d\n", $mv, $pv;

#my $LOW_BATT_COLOR = 'white';
#my $LOW_BATT = 20;
#my $batt_color = $b[0] <= $LOW_BATT ? "^fg($LOW_BATT_COLOR)" : '^fg()';
#printf DZEN "^fn($lfont)^fg(orange)$t^fg()^fn()\n"
	#. "^p(_CENTER)^p(-90)$d^p()\n"
	#. "Batt $batt_color%9s %1s^fg()\n"
	#. "Master %9d\n"
	#. "PCM %12d\n", $b[0], $b[1], $mv, $pv;

close(DZEN);

sub vol
{
	my ($s) = @_;
	my $m = `amixer get $s`;
	$m =~ m/\[(\d+)%\]/;
	return $1;
}

sub batt {
	open(F, '/proc/acpi/battery/BAT0/state'); my @stats = <F>; close(F);
	open(F, '/proc/acpi/battery/BAT0/info'); my @info = <F>; close(F);
	my @br = grep {m/remaining/} @stats;
	my @bf = grep {m/last full/} @info;
	my @st = grep {m/charging state/} @stats;
	$br[0] =~ m/remaining capacity:\s+(\d+)/; my $br = $1;
	$bf[0] =~ m/last full capacity:\s+(\d+)/; my $bf = $1;
	my $batt = $br * 100 / $bf;
	$batt = 100 if $batt > 100;
	$st[0] =~ m/charging state:\s+(\w+)/;
	my $state = $1;
	$state = $state =~ m/discharging/ ? 'D' :
		$state =~ m/charging/ ? 'C' :
		$state =~ m/charged/ ? 'F' : 'U';
	return ($batt, $state);
}

sub gdbar
{
	my ($val, $max_width, $height, $bg, $fg) = @_;
	my $w = int($val / 100 * $max_width + 0.5);
	my $rw = $max_width - $w;
	return "^fg($fg)^r($w" . 'x' . "$height)^fg()"
		. "^fg($bg)^r($rw" . 'x' . "$height)^fg()";
}

sub gdgraph
{
	my ($hist, $max_width, $height, $bg, $fg) = @_;
	my $width = int($max_width / @$hist + 0.5);
	my @r;
	foreach (@$hist)
	{
		my $l = int($_ / 100 * $height + 0.5);
		my $h = $height - $l;
		push(@r, "^fg($fg)^r($width" . 'x' . "$l)^fg()");
	}
	return join '', @r;
}
