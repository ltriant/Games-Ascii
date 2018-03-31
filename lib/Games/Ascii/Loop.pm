package Games::Ascii::Loop;

use warnings;
use strict;

use Moo::Role;
use Types::Standard qw/ArrayRef/;
use Games::Ascii qw/Size Object/;

use Const::Fast;
use Curses;
use Term::ReadKey;
use Time::HiRes qw/usleep/;

requires 'tick';

has _objects => (
	is      => 'rw',
	isa     => ArrayRef[Object],
	default => sub { [] }
);

has _window => (
	is      => 'ro',
	default => sub { Curses->new }
);

const my $INPUT_BUFFER_MAX => 10;

sub push_object {
	my ($self, $object) = @_;
	push @{ $self->_objects } => $object;
}

# TODO Should this be in its own class?
# Event queue?
sub receive_input {
	my ($self) = @_;

	my @buffer;
	ReadMode 'cbreak';

	while ((@buffer < $INPUT_BUFFER_MAX) and (my $key = ReadKey -1)) {
		push @buffer => $key
	}

	ReadMode 'restore';

	# TODO run-length encode?
	@buffer
}

sub broadcast {
	my ($self, $message) = @_;
	$_->receive($self, $message) for @{ $self->_objects };
}

sub loop {
	my ($self) = @_;

	while (1) {
		$self->broadcast( { input => $_ } ) for $self->receive_input;
		$_->update($self, $_, $self->_window) for @{ $self->_objects };

		$self->tick;
		$self->_window->refresh;

		usleep(10000);
	}
}

1;
