package Pong::Component::Physics;

use Moo::Role;
use Pong qw(
	Velocity
);

requires 'move';

has velocity => (
	is      => 'rw',
	isa     => Velocity,
	default => sub { [ 0, 0 ] },
);

1;
