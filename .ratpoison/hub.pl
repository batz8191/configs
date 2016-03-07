#!/usr/bin/perl
use strict;
use IO::Select;
use IO::Socket;

my $dzen = "dzen2 -x 0 -y 1060 -h 20 -w 1110 -ta l -bg '#000000' -fg '#ffffff' -fn '-*-fixed-medium-*-*-*-22-*-*-*-*-*-iso10646-*' -p -e 'button2=collapse'";
my $socketfile = $ENV{HOME} . "/bin/dzen/.hub.sock";
my $statusfile = $ENV{HOME} . "/bin/dzen/.status.sock";
my $RATPOISON = 'ratpoison';

open(my $D, "|$dzen") or die $!;

unlink $socketfile;
my $server = new IO::Socket::UNIX(
	Local => $socketfile,
	Type => SOCK_STREAM,
	Listen => 32
) or die $!;
my $client;
for (1..5) {
	$client = new IO::Socket::UNIX(
		Peer  => $statusfile,
		Type => SOCK_STREAM
	);
	last if $client;
}
$server->autoflush(1);
$D->autoflush(1);

my $sel = IO::Select->new();
$sel->add($server);
while(my @ready = $sel->can_read()) {
	foreach my $f(@ready) {
		if($f == $server) {
			my $n = $server->accept();
			$sel->add($n);
		} else {
			my $data = <$f>;
			if($data) {
				chomp($data);
				if($data =~ m/togglehide/) {
					print $D "^togglehide()\n";
					print $client "togglehide\n";
				} else {
					print $D "$data\n";
				}
			} else {
				$sel->remove($f);
				$f->close();
			}
		}
	}
}
