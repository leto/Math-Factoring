package Math::Factoring;

use warnings;
use strict;
use Math::GMPz qw/:mpz/;
use Math::Primality qw/is_prime/;
use base 'Exporter';
use constant GMP => 'Math::GMPz';
our @EXPORT_OK = qw/factor factor_trial/;
our @EXPORT = qw//;
use Data::Dumper;

=head1 NAME

Math::Factoring - Advanced Factoring Algorithms

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

sub _random()
{
    my $n   = GMP->new(int rand(1e15) );
    my $state = rand_init($n);
    my $rand = GMP->new;
    Rmpz_urandomm($rand, $state, $n,1);
    #warn "return rand=$rand";
    return $rand;
}

# this is fast but only works for certain numbers
# which satisfy smoothness constraints that are currently not being 
# checked for
sub _factor_pollard_rho($$$)
{
    my ($n,$a,$x0) = @_;
    warn "_factor_pollard($n,$a,$x0)\n";
    my ($x,$y,$q,$d) = map { GMP->new } ( 1 .. 4 );
    my ($i,$j) = (1,1);
    $q = 1; $x = $x0; $y = $x0;

    do {
        $x  = ($x*$x + $a ) % $n;
        $y  = ($y*$y + $a ) % $n;
        $y  = ($y*$y + $a ) % $n;
        $q *= ($x - $y);
        $q %= $n;

        $i++;
        $j = 1 if !$j;
        if( ($i % $j ) == 0 ) {
            $j++;
            Rmpz_gcd($d, $q, $n);
            if ($d != 1) {
                if (!is_prime($d)) {
                    no warnings 'prototype';
                    return _factor_pollard_rho( $d,
                            (_random() & 32) - 16,
                             _random() & 31 );
                } else {
                    return $d;
                }
            }
        }
    };
    return 0;

}

sub factor($)
{
    goto \&factor_trial;
}
# this gets rid of prototype warnings
sub factor_trial($);
# this can be sped up a lot by using the Rmpz_* functions
sub factor_trial($)
{
    my $n = shift;
    if ($n >= 0 and $n <= 3) {
        return ("$n");
    }
    $n   = GMP->new($n);
    my $sqrt = GMP->new;
    Rmpz_sqrt($sqrt, $n);

    # speed up factors of perfect squares

    if( Rmpz_perfect_square_p($n) ){
        my @root_factors = factor_trial($sqrt);
        return map { ("$_","$_") } @root_factors;
    }

    my @factors;
    my $cur = GMP->new(2);
    my ($mod,$square) = (GMP->new,GMP->new);
    Rmpz_mul($square,$cur,$cur);

    while( $square <= $n ) {
        Rmpz_mod($mod,$n,$cur);
        if( Rmpz_cmp_ui($mod,0) == 0 ) {
            push @factors,"$cur";
            Rmpz_tdiv_q($n,$n,$cur);  # $n = $n / $cur;
        } else {
            Rmpz_add_ui($cur,$cur,1); # $cur++
        }
        Rmpz_mul($square,$cur,$cur);
    }
    if (@factors == 0) {
        return ("$n");                # it was prime
    }
    if ( Rmpz_cmp_ui($n,1) ) {
        push @factors,"$n";           # add the last factor
    }
    return sort { $a <=> $b } @factors;
}

sub factor_pollard_rho($)
{
    my $n   = GMP->new($_[0]);
    my @factors;
    if ($n >= 0 and $n <= 3) {
        return "$n";
    } else {
        my ($a,$x0) = (1,3);
        my $t;
        while( !is_prime($n) ) {
            $t = _factor_pollard_rho($n,$a,$x0);
            warn "found t=$t,n=$n";
            last if $t == 0;
            push @factors, "$t";
            $n /= $t;
        }
        push @factors, "$n";
    }

    return sort { $a <=> $b } @factors;
}
=head1 SYNOPSIS

    use Math::Factoring;
    my $n = 42;
    my @factors = factor(42); # 2 3 7

=head1 AUTHOR

Jonathan Leto, C<< <jonathan at leto.net> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-math-factoring at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Math::Factoring>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Math::Factoring


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Math::Factoring>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Math::Factoring>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Math::Factoring>

=item * Search CPAN

L<http://search.cpan.org/dist/Math::Factoring>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2009 Jonathan Leto, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

1; # End of Math::Factoring
