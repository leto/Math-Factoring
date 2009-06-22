use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Math::Factoring',
    license             => 'perl',
    dist_author         => 'Jonathan Leto <jonathan@leto.net>',
    dist_version_from   => 'lib/Math/Factoring.pm',
    build_requires => {
        'Test::More' => 0,
    },
    add_to_cleanup      => [ 'Math::Factoring-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
