#!/usr/bin/perl
use warnings;
use strict;


my $basicCell = "	{
		edge: {
			n: undefined,
			e: undefined,
			s: undefined,
			w: undefined,
		},
		properties: {
			stairs: 'none',
			darkness: false,
			spin: false,
			encounterIndex: undefined,
			itemTable: undefined,
		},
	},
";

print "let level = [\n";
for (1 .. 20 * 20) {
	print $basicCell;
}
print "]\n";
