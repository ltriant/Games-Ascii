package Pong::Object;

use Moo;
use Types::Standard qw/Maybe/;
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

has input     => (is => 'ro', isa => Maybe[InputComponent]);
has physics   => (is => 'ro', isa => Maybe[PhysicsComponent]);
has graphics  => (is => 'ro', isa => Maybe[GraphicsComponent]);

sub receive {
	my ($self, $game, $message) = @_;

	if (exists $message->{input} and $self->input) {
		$self->input->update($game, $self, $message->{input});
	}
}

sub update {
	my ($self, $game, $object, $win) = @_;

	$self->graphics->clear($object, $win)         if $self->graphics;
	$self->physics->update($game, $object, $win)  if $self->physics;
	$self->graphics->update($game, $object, $win) if $self->graphics;
}

1;
