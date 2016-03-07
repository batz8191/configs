#!/usr/bin/perl
use warnings;
use strict;
use IO::Socket;

my $RATPOISON = 'ratpoison';
my $padding = `$RATPOISON -c 'set padding'`;
if($padding !~ m/ 0$/) {
	`$RATPOISON -c 'set padding 0 0 0 0'`;
} else {
	`$RATPOISON -c 'set padding 0 0 0 20'`;
}

my $socketfile = $ENV{HOME} . "/bin/dzen/.hub.sock";
my $client = new IO::Socket::UNIX(
	Peer  => $socketfile,
	Type => SOCK_STREAM) or die $!;
print $client "togglehide\n";
$client->flush;
$client->close;
