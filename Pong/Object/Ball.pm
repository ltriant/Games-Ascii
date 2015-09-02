package Pong::Object::Ball;

use Moo;
extends 'Pong::Object';

use Pong::Component::Physics::Ball;

has '+size'  => (default => sub { [ qw/1 1/ ] } );

has '+physics' => (
	default => sub { Pong::Component::Physics::Ball->new}
);

1;
