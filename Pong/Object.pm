package Pong::Object;

use Moo;
use Pong qw(
	Size
	Position
	Direction
	Velocity
	InputComponent
	PhysicsComponent
	GraphicsComponent
);

has size      => (is => 'rw', isa => Size);
has position  => (is => 'rw', isa => Position);
has direction => (is => 'rw', isa => Direction);
has velocity  => (is => 'rw', isa => Velocity);

has input     => (is => 'ro', isa => InputComponent);
has physics   => (is => 'ro', isa => PhysicsComponent);
has graphics  => (is => 'ro', isa => GraphicsComponent);

sub update {
	my ($self, @rest) = @_;

	$self->input->update(@rest)    if $self->input;
	$self->physics->update(@rest)  if $self->physics;
	$self->graphics->update(@rest) if $self->graphics;
}

1;
