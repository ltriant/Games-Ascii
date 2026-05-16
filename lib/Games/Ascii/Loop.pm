package Games::Ascii::Loop;

use v5.42;
use feature 'signatures';

use Moo::Role;
use Types::Standard qw(ArrayRef Maybe Bool);
use Games::Ascii qw(Size Object GraphicsComponent);

use Const::Fast;
use Curses;
use Term::ReadKey;
use Time::HiRes qw(usleep);

requires 'tick';

has scene => (
  is   => 'rw',
  does => GraphicsComponent,
);

has _objects => (
	is      => 'rw',
	isa     => ArrayRef[Object],
	default => sub { [] }
);

has _window => (
	is      => 'ro',
	default => sub { Curses->new }
);

has _running => (
  is      => 'rwp',
  isa     => Bool,
  default => sub { 1 },
);

const my $INPUT_BUFFER_MAX => 10;

sub push_object($self, $object) {
	push @{ $self->_objects } => $object;
}

sub remove_object($self, $object_idx) {
  splice @{ $self->_objects }, $object_idx, 1;
}

# TODO Should this be in its own class?
# Event queue?
# Use the Curses API instead of Term::ReadKey
sub receive_input($self) {
	my @buffer;
	ReadMode 'cbreak';

	while ((@buffer < $INPUT_BUFFER_MAX) and (my $key = ReadKey -1)) {
		push @buffer => $key
	}

	ReadMode 'restore';

	# TODO run-length encode?
	@buffer
}

sub broadcast($self, $message) {
	$_->receive($self, $message) for @{ $self->_objects };
}

sub loop($self) {
  while ($self->_running) {
    $self->_window->erase;
    $self->broadcast( { input => $_ } ) for $self->receive_input;
    $self->scene->draw($self, $self->_window) if $self->scene;
		$_->update($self, $_, $self->_window) for @{ $self->_objects };

		$self->tick;
		$self->_window->refresh;

		usleep(16000);
	}

  $self->_window->clear;
  $self->_window->refresh;
}

sub graceful_shutdown($self) {
  $self->_set__running(0);
}

1;
