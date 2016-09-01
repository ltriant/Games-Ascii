package Pong::Utils;

use warnings;
use strict;

require Exporter;
use base 'Exporter';

our @EXPORT_OK = qw(round);

sub round { int((pop || $_) + 0.5) }

1;
