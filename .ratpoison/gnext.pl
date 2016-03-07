#!/usr/bin/perl
use strict;
use warnings;

my $RATPOISON = 'ratpoison';

my $cmd = $ARGV[0] eq 'next' ? 'gnext' : 'gprev';

my $c = 0;
my @g = `$RATPOISON -c 'groups'`;
my $w;
do {
	`$RATPOISON -c 'select -' -c '$cmd' -c 'next'`;
	$w = `$RATPOISON -c 'info %n'`;
} while ($w =~ m/No window/ && $c < $#g);
