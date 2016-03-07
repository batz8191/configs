#!/usr/bin/perl
use strict;
use warnings;
use String::ShellQuote;
use v5.12;

my @a;
while(<>) {
	chomp;
	next if $_ =~ m/^#/;
	next if $_ =~ m/^\s*$/;
	push(@a, "-c \"$_\"");
}
print `ratpoison @a`;
