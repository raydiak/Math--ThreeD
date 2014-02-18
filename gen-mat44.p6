#!/usr/bin/env perl6

use v6;

use lib $?FILE.path.directory;
use Generator;

Math::ThreeD::Library.new(
    name => 'Mat44',
    constructor => 'mat44',
    dims => [4, 4],
    intro =>
q[method at_pos ($i) is rw {
    self.Array::at_pos($_  ),
    self.Array::at_pos($_+1),
    self.Array::at_pos($_+2),
    self.Array::at_pos($_+3)
        given $i*4;
}

sub mat44-zero() is export {
    Mat44.new(
        0, 0, 0, 0,
        0, 0, 0, 0,
        0, 0, 0, 0,
        0, 0, 0, 0,
    )
}

sub mat44-ident() is export {
    Mat44.new(
        1, 0, 0, 0,
        0, 1, 0, 0,
        0, 0, 1, 0,
        0, 0, 0, 1,
    )
}

sub mat44-trans($x, $y, $z) is export {
    Mat44.new(
        1, 0, 0, $x,
        0, 1, 0, $y,
        0, 0, 1, $z,
        0, 0, 0,  1,
    )
}

sub mat44-scale($x, $y, $z) is export {
    Mat44.new(
        $x,  0,  0, 0,
         0, $y,  0, 0,
         0,  0, $z, 0,
         0,  0,  0, 1,
    )
}

sub mat44-rot-x(Numeric:D $a) is export {
    my ($sin, $cos) = sin($a), cos($a);
    Mat44.new(
        1,    0,     0, 0,
        0, $cos, -$sin, 0,
        0, $sin,  $cos, 0,
        0,    0,     0, 1,
    )
}

sub mat44-rot-y(Numeric:D $a) is export {
    my ($sin, $cos) = sin($a), cos($a);
    Mat44.new(
        $cos, 0, -$sin, 0,
           0, 1,     0, 0,
        $sin, 0,  $cos, 0,
           0, 0,     0, 1,
    )
}

sub mat44-rot-z(Numeric:D $a) is export {
    my ($sin, $cos) = sin($a), cos($a);
    Mat44.new(
        $cos, -$sin, 0, 0,
        $sin,  $cos, 0, 0,
           0,     0, 1, 0,
           0,     0, 0, 1,
    )
}],
    ops => (

        op( operator => '+',
            function => 'add',
            mutator => 'plus',
            args => [[ <obj> ],[ <num> ]],
        ),

        op( operator => '-',
            function => 'sub',
            mutator => 'minus',
            args => [[ <obj> ],[ <num> ]],
        ),

        op( operator => '-',
            function => 'neg',
            mutator => 'negate',
        ),

        op( operator => '*',
            function => 'mul',
            mutator => 'times',
            args => [[ <obj> ],[ <num> ]],
        ),

        op( operator => '/',
            function => 'div',
            mutator => 'divide',
            args => [[ <obj> ],[ <num> ]],
        ),

        op( operator => '%',
            function => 'mod',
            mutator => 'modulus',
            args => [[ <obj> ],[ <num> ]],
        ),

        op( function => 'dump',
            body => 'say $a.perl',
            return => '',
        ),

        op( function => 'inv',
            mutator => 'invert',
            intro =>
q[[[my $s = [
    $a[0][0] * $a[1][1] - $a[1][0] * $a[0][1],
    $a[0][0] * $a[1][2] - $a[1][0] * $a[0][2],
    $a[0][0] * $a[1][3] - $a[1][0] * $a[0][3],
    $a[0][1] * $a[1][2] - $a[1][1] * $a[0][2],
    $a[0][1] * $a[1][3] - $a[1][1] * $a[0][3],
    $a[0][2] * $a[1][3] - $a[1][2] * $a[0][3]
];

my $c = [
    $a[2][0] * $a[3][1] - $a[3][0] * $a[2][1],
    $a[2][0] * $a[3][2] - $a[3][0] * $a[2][2],
    $a[2][0] * $a[3][3] - $a[3][0] * $a[2][3],
    $a[2][1] * $a[3][2] - $a[3][1] * $a[2][2],
    $a[2][1] * $a[3][3] - $a[3][1] * $a[2][3],
    $a[2][2] * $a[3][3] - $a[3][2] * $a[2][3]
];

my $det =
    $s[0] * $c[5] -
    $s[1] * $c[4] +
    $s[2] * $c[3] +
    $s[3] * $c[2] -
    $s[4] * $c[1] +
    $s[5] * $c[0];

die "Cannot invert zero-determinant matrix:\n{$a.perl}" unless $det;

my $invdet = 1 / $det;]]],
            expressions => [
                '( $a[1][1] * $c[5] - $a[1][2] * $c[4] + $a[1][3] * $c[3]) * $invdet',
                '(-$a[0][1] * $c[5] + $a[0][2] * $c[4] - $a[0][3] * $c[3]) * $invdet',
                '( $a[3][1] * $s[5] - $a[3][2] * $s[4] + $a[3][3] * $s[3]) * $invdet',
                '(-$a[2][1] * $s[5] + $a[2][2] * $s[4] - $a[2][3] * $s[3]) * $invdet',
                '(-$a[1][0] * $c[5] + $a[1][2] * $c[2] - $a[1][3] * $c[1]) * $invdet',
                '( $a[0][0] * $c[5] - $a[0][2] * $c[2] + $a[0][3] * $c[1]) * $invdet',
                '(-$a[3][0] * $s[5] + $a[3][2] * $s[2] - $a[3][3] * $s[1]) * $invdet',
                '( $a[2][0] * $s[5] - $a[2][2] * $s[2] + $a[2][3] * $s[1]) * $invdet',
                '( $a[1][0] * $c[4] - $a[1][1] * $c[2] + $a[1][3] * $c[0]) * $invdet',
                '(-$a[0][0] * $c[4] + $a[0][1] * $c[2] - $a[0][3] * $c[0]) * $invdet',
                '( $a[3][0] * $s[4] - $a[3][1] * $s[2] + $a[3][3] * $s[0]) * $invdet',
                '(-$a[2][0] * $s[4] + $a[2][1] * $s[2] - $a[2][3] * $s[0]) * $invdet',
                '(-$a[1][0] * $c[3] + $a[1][1] * $c[1] - $a[1][2] * $c[0]) * $invdet',
                '( $a[0][0] * $c[3] - $a[0][1] * $c[1] + $a[0][2] * $c[0]) * $invdet',
                '(-$a[3][0] * $s[3] + $a[3][1] * $s[1] - $a[3][2] * $s[0]) * $invdet',
                '( $a[2][0] * $s[3] - $a[2][1] * $s[1] + $a[2][2] * $s[0]) * $invdet',
            ],
        ),

        op( function => 'prod',
            mutator => 'product',
            args => [[ <obj> ]],
            expressions => [
                '$a[0][0]*$b[0][0] + $a[0][1]*$b[1][0] + $a[0][2]*$b[2][0] + $a[0][3]*$b[3][0]',
                '$a[0][0]*$b[0][1] + $a[0][1]*$b[1][1] + $a[0][2]*$b[2][1] + $a[0][3]*$b[3][1]',
                '$a[0][0]*$b[0][2] + $a[0][1]*$b[1][2] + $a[0][2]*$b[2][2] + $a[0][3]*$b[3][2]',
                '$a[0][0]*$b[0][3] + $a[0][1]*$b[1][3] + $a[0][2]*$b[2][3] + $a[0][3]*$b[3][3]',
                
                '$a[1][0]*$b[0][0] + $a[1][1]*$b[1][0] + $a[1][2]*$b[2][0] + $a[1][3]*$b[3][0]',
                '$a[1][0]*$b[0][1] + $a[1][1]*$b[1][1] + $a[1][2]*$b[2][1] + $a[1][3]*$b[3][1]',
                '$a[1][0]*$b[0][2] + $a[1][1]*$b[1][2] + $a[1][2]*$b[2][2] + $a[1][3]*$b[3][2]',
                '$a[1][0]*$b[0][3] + $a[1][1]*$b[1][3] + $a[1][2]*$b[2][3] + $a[1][3]*$b[3][3]',
                
                '$a[2][0]*$b[0][0] + $a[2][1]*$b[1][0] + $a[2][2]*$b[2][0] + $a[2][3]*$b[3][0]',
                '$a[2][0]*$b[0][1] + $a[2][1]*$b[1][1] + $a[2][2]*$b[2][1] + $a[2][3]*$b[3][1]',
                '$a[2][0]*$b[0][2] + $a[2][1]*$b[1][2] + $a[2][2]*$b[2][2] + $a[2][3]*$b[3][2]',
                '$a[2][0]*$b[0][3] + $a[2][1]*$b[1][3] + $a[2][2]*$b[2][3] + $a[2][3]*$b[3][3]',
                
                '$a[3][0]*$b[0][0] + $a[3][1]*$b[1][0] + $a[3][2]*$b[2][0] + $a[3][3]*$b[3][0]',
                '$a[3][0]*$b[0][1] + $a[3][1]*$b[1][1] + $a[3][2]*$b[2][1] + $a[3][3]*$b[3][1]',
                '$a[3][0]*$b[0][2] + $a[3][1]*$b[1][2] + $a[3][2]*$b[2][2] + $a[3][3]*$b[3][2]',
                '$a[3][0]*$b[0][3] + $a[3][1]*$b[1][3] + $a[3][2]*$b[2][3] + $a[3][3]*$b[3][3]',
            ],
        ),

    ),
).write('lib/Math/ThreeD/Mat44.pm');

# vim: set expandtab:ts=4:sw=4
