#!/usr/bin/perl


use strict;

# Test with assert on.

$| = 1;
print "1..4\n";
my $t_num = 1;

local $@;
$@ = '';

use Carp::Assert qw(:NDEBUG);
eval { assert(1==0) if DEBUG; };
print "not " if $@;
print "ok ",$t_num++,"\n";

$@ = '';
eval { assert(1==0); };
print "not " if $@;
print "ok ",$t_num++,"\n";

$@ = '';
eval { should('this', 'moofer') if DEBUG };
print "not " if $@ ne '';
print "ok ".$t_num++."\n";

$@ = '';
eval { shouldnt('this', 'this') };
print "not " if $@ ne '';
print "ok ".$t_num++."\n";
