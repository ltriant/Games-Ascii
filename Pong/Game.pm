package Pong::Game;

use Moo;
use Pong qw/Paddle Ball Size/;

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
		$self->ball->position( [ 4, 4 ] );
		$self->ball->direction( [ qw(W N) ] );
		$self->ball->velocity(0.1);
	}
}

sub objects {
	my ($self) = @_;
	return ($self->player1, $self->player2, $self->ball);
}

sub loop {
	my ($self) = @_;

	while (1) {
		print "Loop\n";

		$self->player1->update($self, $self->player1);
		$self->player2->update($self, $self->player2);
		$self->ball->update($self);

		printf "  p1: %.2f, %.2f\n", @{ $self->player1->position };
		printf "  p2: %.2f, %.2f\n", @{ $self->player2->position };
		printf "  b:  %.2f, %.2f, %s%s\n", @{ $self->ball->position }, reverse @{ $self->ball->direction };

		#usleep(10000);
		usleep(100000);
	}
}

1;
