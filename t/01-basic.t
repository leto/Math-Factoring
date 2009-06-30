#!perl

use Test::More tests => 1;
use Math::Factoring qw/factor/;

local $TODO = "implement factor()";
is_deeply( [factor(1)], [1], 'factors of 1 are 1');
