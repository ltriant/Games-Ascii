package Games::Ascii::Object;

use v5.42;
use feature 'signatures';

use Moo;
use Types::Standard qw(Maybe);
use Games::Ascii qw(
	Position
	Size
	InputComponent
);

with qw(
	Games::Ascii::Component::Physics
	Games::Ascii::Component::Graphics
);

has position => (
	is  => 'rw',
	isa => Position
);
has size => (
	is  => 'rw',
	isa => Size
);
has input => (
	is  => 'ro',
	isa => Maybe[InputComponent]
);

sub move { }  # implemented in derived classes
sub draw { }  # implemented in derived classes

sub receive($self, $game, $message) {
	if (exists $message->{input} and $self->input) {
		$self->input->update($game, $self, $message->{input});
	}
}

sub update($self, $game, $object, $win) {
	$self->move($game, $object, $win);
	$self->draw($game, $object, $win);
}

1;
