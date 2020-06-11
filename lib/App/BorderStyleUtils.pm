package App::BorderStyleUtils;

# AUTHORITY
# DATE
# DIST
# VERSION

use 5.010001;
use strict;
use warnings;
use Log::ger;

our %SPEC;

$SPEC{list_border_style_modules} = {
    v => 1.1,
    summary => 'List BorderStyle modules',
    args => {
        detail => {
            schema => 'bool*',
            cmdline_aliases => {l=>{}},
        },
    },
};
sub list_border_style_modules {
    require Module::List::Tiny;

    my %args = @_;

    my @res;
    my %resmeta;

    my $mods = Module::List::Tiny::list_modules(
        "", {list_modules => 1, recurse => 1});
    for my $mod (sort keys %$mods) {
        next unless $mod =~ /(\A|::)BorderStyle::/;
        push @res, $mod;
    }

    [200, "OK", \@res, \%resmeta];
}

1;
# ABSTRACT: CLI utilities related to border styles

=head1 DESCRIPTION

This distribution contains the following CLI utilities:

# INSERT_EXECS_LIST


=head1 SEE ALSO

L<BorderStyle>

=cut
