#!perl

use Test::More tests => 14;
use Math::Factoring qw/factor/;
use Data::Dumper;


my $factor_data = [
    # n     factors (from smallest to largest)
    [ 0     => [ 0    ] ],
    [ 1     => [ 1    ] ],
    [ 4     => [ 2, 2 ] ],
    [ 5     => [ 5    ] ],
    [ 6     => [ 2, 3 ] ],
    [ 7     => [ 7    ] ],
    [ 8     => [ 2, 4 ] ],
    [ 9     => [ 3, 3 ] ],
    [ 10    => [ 2, 5 ] ],
    [ 11     => [ 11    ] ],
    [ 13     => [ 13    ] ],
    [ 50     => [ 2,5,5 ] ],
    [ 858    => [ 2,3,11,13 ] ],
    [ 901    => [ 17, 53 ] ],
];

local $TODO = "implement factor()";
for my $f (@$factor_data) {
    my ($num,$factors) = @$f;
    warn Dumper [ 'expected',$factors, [ 'got',factor($num) ] ];

    is_deeply( [factor($num)], $factors,
        sprintf("factors of %d are %s", $num, join "*",@$factors )
    );
}
