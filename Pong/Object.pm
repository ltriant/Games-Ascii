package Pong::Object;

use Moo;
use Types::Standard qw/Maybe/;
use Pong qw(InputComponent);

with qw(
	Pong::Component::Physics
	Pong::Component::Graphics
);

has input => (
	is  => 'ro',
	isa => Maybe[InputComponent]
);

sub move { }
sub draw { }

sub receive {
	my ($self, $game, $message) = @_;

	if (exists $message->{input} and $self->input) {
		$self->input->update($game, $self, $message->{input});
	}
}

sub update {
	my ($self, $game, $object, $win) = @_;

	$self->clear($object, $win);
	$self->move($game, $object, $win);
	$self->draw($game, $object, $win);
}

1;
