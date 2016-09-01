package Pong::Component::Physics;

use Moo::Role;
use Pong qw(
	Direction
	Velocity
);

requires 'move';

has direction => (
	is  => 'rw',
	isa => Direction
);
has velocity => (
	is  => 'rw',
	isa => Velocity
);

1;
