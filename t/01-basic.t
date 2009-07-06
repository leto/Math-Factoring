#!perl

use Test::More tests => 20;
use Math::Factoring qw/factor factor_trial/;
use Data::Dumper;

my $factor_data = [
    # n     factors (from smallest to largest)
    [ 0     => [ 0    ] ],
    [ 1     => [ 1    ] ],
    [ 4     => [ 2, 2 ] ],
    [ 5     => [ 5    ] ],
    [ 6     => [ 2, 3 ] ],
    [ 7     => [ 7    ] ],
    [ 8     => [ 2, 2, 2 ] ],
    [ 9     => [ 3, 3 ] ],
    [ 10    => [ 2, 5 ] ],
    [ 11     => [ 11    ] ],
    [ 12     => [ 2, 2, 3]  ],
    [ 13     => [ 13    ] ],
    [ 21,    => [ 3, 7 ] ],
    [ 50     => [ 2,5,5 ] ],
    [ 858    => [ 2,3,11,13 ] ],
    [ 901    => [ 17, 53 ] ],
    [ 2**10  => [ (2) x 10 ] ],
    [ 101**2  => [ 101,101 ] ],
    [ 2*13**5 => [ 2, (13) x 5 ] ],
    [ (101**2)*(53**2)  => [ 53,53,101,101 ] ],
];

for my $f (@$factor_data) {
    my ($num,$factors,$todo) = @$f;
    local $TODO = $todo;

    is_deeply( [factor($num)], $factors,
        sprintf("factors of %d are %s", $num, join "*",@$factors )
    );
}
