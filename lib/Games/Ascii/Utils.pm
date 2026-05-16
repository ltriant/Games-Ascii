package Games::Ascii::Utils;

use v5.42;
use feature 'signatures';

require Exporter;
use base 'Exporter';

our @EXPORT_OK = qw(round min max rand_int curses_colors);

sub round { int((pop || $_) + 0.5) }
sub min($x, $y) { $x < $y ? $x : $y }
sub max($x, $y) { $x > $y ? $x : $y }
sub rand_int($lo, $hi) { int(rand($hi - $lo + 1)) + $lo }
sub curses_colors(@rgb) { map { 4 * $_ } @rgb }

1;
