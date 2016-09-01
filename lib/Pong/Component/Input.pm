package Pong::Component::Input;

use Moo;
use Pong qw(KeyboardChar);
extends 'Pong::Component';

has left  => (is => 'ro', isa => KeyboardChar);
has right => (is => 'ro', isa => KeyboardChar);

sub update { }

1;
