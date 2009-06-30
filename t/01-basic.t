#!perl

use Test::More tests => 7;
use Math::Factoring qw/factor/;

local $TODO = "implement factor()";

my $factor_data = [
    [ 0 => [ 0 ] ],
    [ 1 => [ 1 ] ],
    [ 4 => [ 2, 2 ] ],
    [ 6 => [ 2, 3 ] ],
    [ 8 => [ 2, 4 ] ],
    [ 9 => [ 3, 3 ] ],
    [ 10 => [ 2, 5 ] ],
];

for my $f (@$factor_data) {
    my ($num,$factors) = @$f;
    is_deeply( [factor($num)], $factors,
        sprintf("factors of %d are %s", $num, join "*",@$factors )
    );
}
