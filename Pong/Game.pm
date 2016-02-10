package Pong::Game;

use Moo;
use Pong qw/Paddle Ball Size/;

use Curses;
use Term::ReadKey;
use Time::HiRes qw/usleep/;

has player1 => (is => 'ro', isa => Paddle);
has player2 => (is => 'ro', isa => Paddle);
has ball    => (is => 'ro', isa => Ball);
has size    => (is => 'ro', isa => Size);

sub BUILD {
	my ($self) = @_;

	$self->player1->position( [ 0, 8 ] );
	$self->player2->position( [ 0, 1 ] );

	if ($self->ball) {
		$self->ball->position( [ 2, 7 ] );
		$self->ball->direction( [ qw(W N) ] );
		$self->ball->velocity(0.1);
	}
}

sub objects {
	my ($self) = @_;
	return ($self->player1, $self->player2, $self->ball);
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
	$_->receive($self, $message) for $self->objects;
}

sub loop {
	my ($self) = @_;

	my $win = Curses->new;

	while (1) {
#		print "Loop\n";

		$self->broadcast( { input => $_ } ) for $self->receive_input;
		$_->update($self, $_, $win) for $self->objects;

#		printf "  p1: %.2f, %.2f\n", @{ $self->player1->position };
#		printf "  p2: %.2f, %.2f\n", @{ $self->player2->position };
#		printf "  b:  %.2f, %.2f, %s%s\n", @{ $self->ball->position }, reverse @{ $self->ball->direction };

		usleep(10000);
		#usleep(1000000);
	}
}

1;
