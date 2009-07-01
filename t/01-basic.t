#!perl

use Test::More tests => 7;
use Math::Factoring qw/factor/;
use Data::Dumper;


my $factor_data = [
    # n     factors (from smallest to largest)
    [ 0     => [ 0 ] ],
    [ 1     => [ 1 ] ],
    [ 4     => [ 2, 2 ] ],
    [ 6     => [ 2, 3 ] ],
    [ 8     => [ 2, 4 ] ],
    [ 9     => [ 3, 3 ] ],
    [ 10    => [ 2, 5 ] ],
];

local $TODO = "implement factor()";
for my $f (@$factor_data) {
    my ($num,$factors) = @$f;
    is_deeply( [factor($num)], $factors,
        sprintf("factors of %d are %s", $num, join "*",@$factors )
    );
}
