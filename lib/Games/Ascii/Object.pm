package Games::Ascii::Object;

use Moo;
use Types::Standard qw/Maybe/;
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

sub receive {
	my ($self, $game, $message) = @_;

	if (exists $message->{input} and $self->input) {
		$self->input->update($game, $self, $message->{input});
	}
}

sub update {
	my ($self, $game, $object, $win) = @_;

	$self->clear($game, $object, $win);
	$self->move($game, $object, $win);
	$self->draw($game, $object, $win);
}

1;
