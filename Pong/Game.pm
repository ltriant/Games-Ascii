package Pong::Game;

use Moo;
use Types::Standard qw/ArrayRef/;
use Pong qw/Paddle Ball Size Object/;

use Curses;
use Term::ReadKey;
use Time::HiRes qw/usleep/;

with 'Pong::Component::Observer';

has player1 => ( is => 'ro', isa => Paddle, required => 1 );
has player2 => ( is => 'ro', isa => Paddle, required => 1 );
has ball    => ( is => 'ro', isa => Ball,   required => 1 );
has size    => ( is => 'ro', isa => Size,   required => 1 );

has _objects => ( is => 'rw', isa => ArrayRef[Object] );
has _window => (
	is      => 'ro',
	default => sub { Curses->new }
);

sub BUILD {
	my ($self) = @_;

	$self->player1->position( [ 7, 8 ] );
	$self->player2->position( [ 0, 1 ] );

	$self->ball->position( [ 2, 7 ] );
	$self->ball->direction( [ qw(W N) ] );
	$self->ball->velocity(0.05);
	$self->ball->push_observer($self);

	$self->_objects( [ $self->player1, $self->player2, $self->ball ] );
}

sub on_notify {
	my ($self, $message) = @_;

	if (my $obj = $message->{score}) {
		# TODO player scored
	}
}

# TODO Should this be in its own class?
# Event queue?
sub receive_input {
	my ($self) = @_;

	my @buffer;
	ReadMode 'cbreak';

	while (my $key = ReadKey -1) {
		push @buffer => $key
	}

	ReadMode 'restore';

	@buffer
}

sub broadcast {
	my ($self, $message) = @_;
	$_->receive($self, $message) for @{ $self->_objects };
}

sub loop {
	my ($self) = @_;

	my $win = $self->_window;

	while (1) {
#		print "Loop\n";

		$self->broadcast( { input => $_ } ) for $self->receive_input;
		$_->update($self, $_, $win) for @{ $self->_objects };

#		printf "  p1: %.2f, %.2f\n", @{ $self->player1->position };
#		printf "  p2: %.2f, %.2f\n", @{ $self->player2->position };
#		printf "  b:  %.2f, %.2f, %s%s\n", @{ $self->ball->position }, reverse @{ $self->ball->direction };

		usleep(10000);
		#usleep(1000000);
	}
}

1;
