package Pong::Object;

use Moo;
use Types::Standard qw/Maybe/;
use Pong qw(
	Size
	Position
	Direction
	Velocity
	InputComponent
);

has size      => (is => 'rw', isa => Size);
has position  => (is => 'rw', isa => Position);
has direction => (is => 'rw', isa => Direction);
has velocity  => (is => 'rw', isa => Velocity);
has input     => (is => 'ro', isa => Maybe[InputComponent]);

sub receive {
	my ($self, $game, $message) = @_;

	if (exists $message->{input} and $self->input) {
		$self->input->update($game, $self, $message->{input});
	}
}

sub update {
	my ($self, $game, $object, $win) = @_;

	$self->clear($object, $win)       if $self->can('clear');
	$self->move($game, $object, $win) if $self->can('move');
	$self->draw($game, $object, $win) if $self->can('draw');
}

1;
