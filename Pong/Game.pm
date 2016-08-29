package Pong::Game;

use Moo;
use Types::Standard qw/ArrayRef/;
use Pong qw/Paddle Ball Size Object Scoreboard/;

use Const::Fast;
use Curses;
use Term::ReadKey;
use Time::HiRes qw/usleep/;

has player1 => ( is => 'ro', isa => Paddle,     required => 1 );
has player2 => ( is => 'ro', isa => Paddle,     required => 1 );
has ball    => ( is => 'ro', isa => Ball,       required => 1 );
has size    => ( is => 'ro', isa => Size,       required => 1 );
has scores  => ( is => 'rw', isa => Scoreboard, default  => sub { {} } );

has _objects => ( is => 'rw', isa => ArrayRef[Object] );
has _window => (
	is      => 'ro',
	default => sub { Curses->new }
);

const my $INPUT_BUFFER_MAX => 10;

sub BUILD {
	my ($self) = @_;
	$self->init;
	$self->ball->push_observer(\&on_notify, $self);
	$self->_objects( [ $self->player1, $self->player2, $self->ball ] );
	$self->reset;
}

sub init {
	my ($self) = @_;
	$self->reset_players;
	$self->reset_ball;
	$self->_window->clear;
}

sub reset_players {
	my ($self) = @_;
	$self->player1->position( [ 7, 8 ] );
	$self->player2->position( [ 0, 1 ] );
}

sub reset_ball {
	my ($self) = @_;
	$self->ball->velocity(0.05);
	$self->ball->position( [ 2, 7 ] );
	$self->ball->direction( [ qw(W N) ] );
}

sub reset {
	my ($self) = @_;
	$self->scores->{ $self->player1 } = 0;
	$self->scores->{ $self->player2 } = 0;
}

sub on_notify {
	my ($self, $message) = @_;

	if (my $player = $message->{score}) {
		$self->scores->{ $player } += 1;
		$self->reset_ball;
		$self->_window->clear;
	}
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
#		print "Loop\n";

		$self->broadcast( { input => $_ } ) for $self->receive_input;
		$_->update($self, $_, $self->_window) for @{ $self->_objects };
		$self->_window->addstr(
			0, 0,
			sprintf("Player 1: %d, Player 2: %d",
				$self->scores->{ $self->player1 },
				$self->scores->{ $self->player2 }
			)
		);
		$self->_window->refresh;

		$self->_window->addstr( 12, 0,
			sprintf( "p1: %2.2f, %2.2f", @{ $self->player1->position } ) );
		$self->_window->addstr( 13, 0,
			sprintf( "p2: %2.2f, %2.2f", @{ $self->player2->position } ) );
		$self->_window->addstr(
			14, 0,
			sprintf( " b: %2.2f, %2.2f, %s%s",
				$self->ball->position->[0],
				$self->ball->position->[1],
				$self->ball->direction->[1],
				$self->ball->direction->[0],
			)
		);

		usleep(10000);
	}
}

1;
