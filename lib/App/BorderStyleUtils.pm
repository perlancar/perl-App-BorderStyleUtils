package App::BorderStyleUtils;

# AUTHORITY
# DATE
# DIST
# VERSION

use 5.010001;
use strict;
use utf8;
use warnings;
use Log::ger;

our %SPEC;

$SPEC{list_border_style_modules} = {
    v => 1.1,
    summary => 'List BorderStyle modules',
    args => {
        detail => {
            schema => 'bool*',
            summary => 'Currently does not do anything yet',
            cmdline_aliases => {l=>{}},
        },
    },
    examples => [
        {
            summary => 'List style names',
            args => {},
        },
        #{
        #    summary => 'List style names and their descriptions',
        #    args => {detail=>1},
        #},
    ],
};
sub list_border_style_modules {
    require Module::List::Tiny;

    my %args = @_;

    my @res;
    my %resmeta;

    my $mods = Module::List::Tiny::list_modules(
        "BorderStyle::", {list_modules => 1, recurse => 1});
    for my $mod (sort keys %$mods) {
        $mod =~ s/\ABorderStyle:://;
        push @res, $mod;
    }

    [200, "OK", \@res, \%resmeta];
}

$SPEC{show_border_style} = {
    v => 1.1,
    summary => 'Show example table with specified border style',
    args => {
        style => {
            schema => 'perl::borderstyle::modname_with_optional_args*',
            req => 1,
            pos => 0,
        },
    },
    examples => [
        {
            summary => 'Show the details for the ASCII::SingleLineDoubleAfterHeader border style',
            args => {style=>'ASCII::SingleLineDoubleAfterHeader'},
        },
    ],
};
sub show_border_style {
    require Module::Load::Util;
    require String::Pad;

    my %args = @_;

    my @res;
    my %resmeta;

    my $bs = Module::Load::Util::instantiate_class_with_optional_args(
        {ns_prefix=>'BorderStyle'}, $args{style});

    my $map = {
        A => sub { $bs->get_border_char(0, 0) // '' },
        B => sub { $bs->get_border_char(0, 1) // '' },
        C => sub { $bs->get_border_char(0, 2) // '' },
        D => sub { $bs->get_border_char(0, 3) // '' },
        E => sub { $bs->get_border_char(1, 0) // '' },
        F => sub { $bs->get_border_char(1, 1) // '' },
        G => sub { $bs->get_border_char(1, 2) // '' },
        H => sub { $bs->get_border_char(2, 0) // '' },
        I => sub { $bs->get_border_char(2, 1) // '' },
        J => sub { $bs->get_border_char(2, 2) // '' },
        K => sub { $bs->get_border_char(2, 3) // '' },
        a => sub { $bs->get_border_char(2, 4) // '' },
        b => sub { $bs->get_border_char(2, 5) // '' },
        L => sub { $bs->get_border_char(3, 0) // '' },
        M => sub { $bs->get_border_char(3, 1) // '' },
        N => sub { $bs->get_border_char(3, 2) // '' },
        O => sub { $bs->get_border_char(4, 0) // '' },
        P => sub { $bs->get_border_char(4, 1) // '' },
        Q => sub { $bs->get_border_char(4, 2) // '' },
        R => sub { $bs->get_border_char(4, 3) // '' },
        e => sub { $bs->get_border_char(4, 4) // '' },
        f => sub { $bs->get_border_char(4, 5) // '' },
        g => sub { $bs->get_border_char(4, 6) // '' },
        h => sub { $bs->get_border_char(4, 7) // '' },
        S => sub { $bs->get_border_char(5, 0) // '' },
        T => sub { $bs->get_border_char(5, 1) // '' },
        U => sub { $bs->get_border_char(5, 2) // '' },
        V => sub { $bs->get_border_char(5, 3) // '' },

        'Ȧ' => sub { $bs->get_border_char(6, 0) // '' },
        'Ḃ' => sub { $bs->get_border_char(6, 1) // '' },
        'Ċ' => sub { $bs->get_border_char(6, 2) // '' },
        'Ḋ' => sub { $bs->get_border_char(6, 3) // '' },

        'Ṣ' => sub { $bs->get_border_char(7, 0) // '' },
        'Ṭ' => sub { $bs->get_border_char(7, 1) // '' },
        'Ụ' => sub { $bs->get_border_char(7, 2) // '' },
        'Ṿ' => sub { $bs->get_border_char(7, 3) // '' },

        x => sub { 'x' },
        y => sub { 'y' },
        ###

        t0 => sub { "Positions for border character" },
        t1 => sub { "Table with header row, without row/column spans" },
        t2 => sub { "Table without header row, with data rows" },
        t3 => sub { "Table with header row, but without any data row" },
        t4 => sub { "Table with row/column spans" },
        t5 => sub { "top border" },
        t6 => sub { "header row" },
        t7 => sub { "separator between header & data row" },
        t8 => sub { "data row" },
        t9 => sub { "separator between data rows" },
        t10=> sub { "bottom border" },
        t11=> sub { "top border (for case when there is no header row)" },
        t12=> sub { "bottom border (for case when there is header row but no data row)" },
        _symbols => sub {
            my $template = shift;
            if ($template =~ /\A[.,]+\z/) {
                String::Pad::pad($template =~ /,/ ? 'header' : 'cell', length($template), 'r', ' ', 1);
            }
            #die "BUG: Unknown template '$template'";
        },
    };

    my $table = <<'_';
# t0

 ---------------------------------------------
 y\x  0    1    2    3    4    5    6    7
  0  'A'  'B'  'C'  'D'                              <--- t5
  1  'E'  'F'  'G'                                   <--- t6
  2  'H'  'I'  'J'  'K'  'a'  'b'                    <--- t7
  3  'L'  'M'  'N'                                   <--- t8
  4  'O'  'P'  'Q'  'R'  'e'  'f'  'g'  'h'          <--- t9
  5  'S'  'T'  'U'  'V'                              <--- t10

  6  'Ȧ'  'Ḃ'  'Ċ'  'Ḋ'                              <--- t11
  7  'Ṣ'  'Ṭ'  'Ụ'  'Ṿ'                              <--- t12
 ---------------------------------------------

ABBBBBBBBCBBBBBBBBD     #
E ,,,,,, F ,,,,,, G     #
HIIIIIIIIJIIIIIIIIK     #
L ...... M ...... N     # t1
OPPPPPPPPQPPPPPPPPR     #
L ...... M ...... N     #
STTTTTTTTUTTTTTTTTV     #

ȦḂḂḂḂḂḂḂḂĊḂḂḂḂḂḂḂḂḊ     #
L ...... M ...... N     # t2
OPPPPPPPPQPPPPPPPPR     #
L ...... M ...... N     #
STTTTTTTTUTTTTTTTTV     #

ABBBBBBBBCBBBBBBBBD     #
E ,,,,,, F ,,,,,, G     # t3
ṢṬṬṬṬṬṬṬṬỤṬṬṬṬṬṬṬṬṾ     #

ABBBBBBBBBBBCBBBBBCBBBBBD     #
E ,,,,,,,,, F ,,, F ,,, G     #
HIIIIIaIIIIIJIIIIIbIIIIIK     #
L ... M ... M ......... N     #
OPPPPPfPPPPPQPPPPPePPPPPR     #
L ......... M ... M ... N     #
OPPPPPPPPPPPQPPPPPfPPPPPR     # t4
L ......... M ......... N     #
L           gPPPPPPPPPPPR     #
L           M ......... N     #
OPPPPPPPPPPPh           N     #
L ......... M           N     #
STTTTTTTTTTTUTTTTTTTTTTTV     #
_

    $table =~ s{([A-Za-su-zȦḂĊḊṢṬỤṾ#]|t\d+|([.,])+)}
               {
                   $2 ? $map->{_symbols}->($1) :
                       $map->{$1} ? $map->{$1}->() : $1
               }eg;

    [200, "OK", $table];
}

1;
# ABSTRACT: CLI utilities related to border styles

=head1 DESCRIPTION

This distribution contains the following CLI utilities:

# INSERT_EXECS_LIST


=head1 SEE ALSO

L<BorderStyle>

=cut
