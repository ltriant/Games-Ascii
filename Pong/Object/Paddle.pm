package Pong::Object::Paddle;

use Moo;
extends 'Pong::Object';

use Pong::Component::Physics::Paddle;

# position is the left edge of the paddle
has '+size' => (default => sub { [ qw/3 1/ ] } );
has '+velocity' => (default => sub { 0 } );

has '+physics' => (
	default => sub { Pong::Component::Physics::Paddle->new }
);

1;
