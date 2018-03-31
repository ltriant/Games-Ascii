package Games::Ascii::Component::Input;

use Moo;
use Types::Standard qw/Maybe/;
use Games::Ascii qw(KeyboardChar);
extends 'Games::Ascii::Component';

has left  => (is => 'ro', isa => Maybe[KeyboardChar]);
has right => (is => 'ro', isa => Maybe[KeyboardChar]);
has up    => (is => 'ro', isa => Maybe[KeyboardChar]);
has down  => (is => 'ro', isa => Maybe[KeyboardChar]);

sub update { }

1;
