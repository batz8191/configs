#!/usr/bin/perl
use strict;
use IO::Select;
use IO::Socket;
use POSIX qw(strftime);
use Time::HiRes qw(usleep);

my $socketfile = $ENV{HOME} . "/bin/dzen/.status.sock";
unlink $socketfile;
my $server = new IO::Socket::UNIX(
	Local => $socketfile,
	Type => SOCK_STREAM,
	Listen => 32
) or die $!;
$server->autoflush(1);
my $sel = IO::Select->new();
$sel->add($server);

# TODO may be worth changing to c++?
my $dzen = "$ENV{HOME}/temp/dzen/dzen2 -x 1390 -y 1060 -h 20 -w 530 -ta r -sa l -l 20 -bg '#000000' -fg '#ffffff' -fn '-*-Inconsolata-medium-r-normal-*-26-*-*-*-*-*-*-*' -p -e 'entertitle=ungrabkeys,uncollapse,unhide;leavetitle=collapse'";
open(my $D, "|$dzen") or die $!;
$D->autoflush(1);

open(my $CPU, "/proc/stat") or die $!;
open(my $TX_BYTES, "/sys/class/net/wlan0/statistics/tx_bytes") or die $!;
open(my $RX_BYTES, "/sys/class/net/wlan0/statistics/rx_bytes") or die $!;

my $LOW_BATT_COLOR = '#ffff00';
my $LOW_BATT = 20;
my $GD_WIDTH = 220;
my $GD_HEIGHT = 10;
my $GD_GRAPH_HEIGHT = 120;

# In 1/10 s
my %waits = (
	cpu => 20,
	mem => 20,
	tx_bytes => 20,
	rx_bytes => 20,
	batt => 20,
	vol => 10,
	date => 50,
	keyboard => 50,
	updates => 3000,
);

my @cpu_hist = (0) x 50;
my @mem_hist = (0) x 50;
my @tx_hist = (0) x 50;
my @rx_hist = (0) x 50;

my $c = -1;
my ($date, $keyboard, $updates, @batt, @state, @master, @pcm, @cpu, @mem, @tx_bytes, @rx_bytes);
while(1)
{
	++$c;
	$c = 0 if $c > 100000;
	my $hide = 0;
	while(my @ready = $sel->can_read(0.1)) {
		foreach my $f(@ready) {
			if($f == $server) {
				my $n = $server->accept();
				$sel->add($n);
			} else {
				my $data = <$f>;
				if($data) {
					chomp($data);
					if($data =~ m/togglehide/) {
						$hide = 1;
					}
				} else {
					$sel->remove($f);
					$f->close();
				}
			}
		}
	}
	if($hide) {
		print $D "^togglehide()\n";
	} else {
		if(($c % $waits{cpu}) == 0) { @cpu = get_cpu(); }
		if(($c % $waits{mem}) == 0) { @mem = get_mem(); }
		if(($c % $waits{tx_bytes}) == 0) { @tx_bytes = get_tx(); }
		if(($c % $waits{rx_bytes}) == 0) { @rx_bytes = get_rx(); }
		if(($c % $waits{vol}) == 0) { @master = get_vol('Master'); @pcm = get_vol('PCM'); }
		if(($c % $waits{batt}) == 0) { @batt = get_batt(); }
		if(($c % $waits{date}) == 0) { $date = get_date(); }
		if(($c % $waits{keyboard}) == 0) { $keyboard = get_keyboard(); }
		if(($c % $waits{updates}) == 0) { $updates = get_updates(); }
		my $batt_color = $batt[1] <= $LOW_BATT ? "^fg($LOW_BATT_COLOR)" : '^fg()';
		printf $D "^tw()[ %d%% %d%% | $batt_color%d%s^fg() ] ^ca(1,$ENV{HOME}/bin/dzen/dzen-cal.sh)^fg(orange)$date^fg()^ca()\n"
			. "Volume:\n"
			. "    %6s: %4d $master[2]\n"
			. "    %6s: %4d $pcm[2]\n"
			. "^fg(#777700)^r(500x5)^fg()\n"
			. "Battery:\n"
			. "    %7s $batt_color%3d$batt[2]^fg() $batt[3]\n"
			. "^fg(#777700)^r(500x5)^fg()\n"
			. "Cpu:\n"
			. "    %7s %4d $cpu[2]\n"
			. "^fg(#777700)^r(500x5)^fg()\n"
			. "Memory:\n"
			. "    %7s %4d $mem[2]\n"
			. "^fg(#777700)^r(500x5)^fg()\n"
			. "Network:\n"
			. "    %7s %4d $tx_bytes[2]\n"
			. "    %7s %4d $rx_bytes[2]\n"
			. "^fg(#777700)^r(500x5)^fg()\n"
			. "%7s:       %6s\n"
			. "^fg(#777700)^r(500x5)^fg()\n"
			. "%7s:       %6d\n",
				$master[1], $pcm[1], $batt[1], $batt[2],
				$master[0], $master[1],
				$pcm[0], $pcm[1],
				'', $batt[1],
				'', $cpu[1],
				'', $mem[1],
				$tx_bytes[0], $tx_bytes[1],
				$rx_bytes[0], $rx_bytes[1],
				'Layout', $keyboard,
				'Updates', $updates;
		usleep 100000;
	}
}
print "Exiting\n";
$D->close;
$CPU->close;

sub get_date
{
	return strftime "%a %m-%d-%Y %I:%M %p", localtime;
}

sub get_keyboard
{
	my $r = `setxkbmap -print`;
	return $r =~ m/dvorak/ ? 'dvorak' : 'us';
}

sub get_updates
{
	return scalar(grep {/^Inst/} split(/\n/, `apt-get -s upgrade`));
}

sub get_batt
{
	# TODO make this persistent
	open(F, '/proc/acpi/battery/BAT0/state'); my @stats = <F>; close(F);
	open(F, '/proc/acpi/battery/BAT0/info'); my @info = <F>; close(F);
	my @br = grep {m/remaining/} @stats;
	my @bf = grep {m/last full/} @info;
	my @st = grep {m/charging state/} @stats;
	$br[0] =~ m/remaining capacity:\s+(\d+)/; my $br = $1;
	$bf[0] =~ m/last full capacity:\s+(\d+)/; my $bf = $1;
	my $batt = $br * 100 / $bf;
	$batt = 100 if $batt > 100;
	$st[0] =~ m/charging state:\s+(\w+)/; my $state = $1;
	$state = $state =~ m/discharging/ ? 'D' :
		$state =~ m/charging/ ? 'C' :
		$state =~ m/charged/ ? 'F' : 'U';
	return ('Batt', $batt, $state, gdbar($batt, $GD_WIDTH, $GD_HEIGHT, '#222222', $state eq 'D' ? '#ffff00' : '#ff0000'));
}

sub get_vol
{
	my ($s) = @_;
	my $m = `amixer get $s`;
	$m =~ m/\[(\d+)%\]/;
	return ($s, $1, gdbar($1, $GD_WIDTH, $GD_HEIGHT, '#222222', 'orange'));
}

my ($old_user, $old_sys, $old_idle, $old_iowait) = (0) x 5;
sub get_cpu
{
	my $r = 0;
	seek($CPU, 0, 0);
	while(<$CPU>)
	{
		if(m/cpu\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)/i)
		{
			my ($new_user, $unice, $new_sys, $new_idle, $new_iowait) = ($1, $2, $3, $4, $5);
			$new_user += $unice;
			my $user = $new_user - $old_user;
			my $sys = $new_sys - $old_sys;
			my $idle = $new_idle - $old_idle;
			my $iowait = $new_iowait - $old_iowait;
			my $max = $user + $sys + $idle + $iowait;
			my $val = $user + $sys + $iowait;
			($old_user, $old_sys, $old_idle, $old_iowait) = ($new_user, $new_sys, $new_idle, $new_iowait);
			$r = $val / $max * 100;
			last;
		}
	}
	shift(@cpu_hist);
	push(@cpu_hist, $r);
	return ('Cpu', sprintf('%3.2f', $r), gdgraph(\@cpu_hist, $GD_WIDTH, $GD_GRAPH_HEIGHT, '#222222', '#ff00ff'));
}

sub get_mem
{
	# TODO make this persistent
	open(F, '<', '/proc/meminfo');
	my @l = <F>;
	close(F);
	my @mf = grep {m/memfree/i} @l;
	my @mt = grep {m/memtotal/i} @l;
	$mf[0] =~ m/(\d+)/; my $mf = $1;
	$mt[0] =~ m/(\d+)/; my $mt = $1;
	my $mem = $mt == 0 ? 0 : 100 - $mf * 100 / $mt;
	shift(@mem_hist);
	push(@mem_hist, $mem);
	return ('Mem', sprintf('%3.2f', $mem), gdgraph(\@mem_hist, $GD_WIDTH, $GD_GRAPH_HEIGHT, '#222222', '#000077'));
}

my ($old_tx_bytes, $old_rx_bytes, $max_tx_bytes, $max_rx_bytes) = (0) x 3;
sub get_tx
{
	seek($TX_BYTES, 0, 0);
	my @l = <$TX_BYTES>;
	my $cur = ($l[0] - $old_tx_bytes) / $waits{tx_bytes} / 1024; # 1024 bytes / kb
	my $first = $old_tx_bytes == 0;
	$old_tx_bytes = $l[0]+0;
	unless($first)
	{
		shift(@tx_hist);
		push(@tx_hist, $cur);
		$max_tx_bytes = $cur if $cur > $max_tx_bytes;
		if($max_tx_bytes)
		{
			my @t = map {100 * $_ / $max_tx_bytes} @tx_hist;
			return ('TX', sprintf('%3.2f', $cur), gdgraph(\@t, $GD_WIDTH, $GD_GRAPH_HEIGHT, '#222222', '#007700'));
		}
		return ('TX', sprintf('%3.2f', $cur), '');
	}
}

sub get_rx
{
	seek($RX_BYTES, 0, 0);
	my @l = <$RX_BYTES>;
	my $cur = ($l[0] - $old_rx_bytes) / $waits{rx_bytes} / 1024; # 1024 bytes / kb
	my $first = $old_rx_bytes == 0;
	$old_rx_bytes = $l[0]+0;
	unless($first)
	{
		shift(@rx_hist);
		push(@rx_hist, $cur);
		$max_rx_bytes = $cur if $cur > $max_rx_bytes;
		if($max_rx_bytes)
		{
			my @t = map {100 * $_ / $max_rx_bytes} @rx_hist;
			return ('RX', sprintf('%3.2f', $cur), gdgraph(\@t, $GD_WIDTH, $GD_GRAPH_HEIGHT, '#222222', '#557700'));
		}
		return ('RX', sprintf('%3.2f', $cur), '');
	}
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

sub max { my $x = shift; for (@_) { $x = $_ if $x < $_; } return $x; }
