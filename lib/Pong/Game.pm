package Pong::Game;

use Moo;
use Games::Ascii qw/Size/;
use Pong qw/Paddle Ball Scoreboard/;

with 'Games::Ascii::Loop';

has player1 => ( is => 'ro', isa => Paddle,     required => 1 );
has player2 => ( is => 'ro', isa => Paddle,     required => 1 );
has ball    => ( is => 'ro', isa => Ball,       required => 1 );
has size    => ( is => 'ro', isa => Size,       required => 1 );
has scores  => ( is => 'rw', isa => Scoreboard, default  => sub { {} } );

sub BUILD {
	my ($self) = @_;
	$self->init;
	$self->ball->push_observer(\&on_notify, $self);

	for ($self->player1, $self->player2, $self->ball) {
		$self->push_object($_);
	}

	$self->new_game;
}

sub init {
	my ($self) = @_;
	$self->reset_players;
	$self->reset_ball;
	$self->_window->clear;
}

sub reset_players {
	my ($self) = @_;
	$self->player1->position( [ 7, 9 ] );
	$self->player2->position( [ 0, 1 ] );
}

sub reset_ball {
	my ($self) = @_;
	$self->ball->velocity->[0] = 0.05;
	$self->ball->velocity->[1] = 0.05;
	$self->ball->position( [ 5, 5 ] );
}

sub new_game {
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

sub tick {
	my ($self) = @_;

	$self->_window->addstr(
		11, 0,
		sprintf("Player 1: %d, Player 2: %d",
			$self->scores->{ $self->player1 },
			$self->scores->{ $self->player2 }
		)
	);
	$self->_window->addstr( 12, 0,
		sprintf( "p1: %2.2f, %2.2f", @{ $self->player1->position } ) );
	$self->_window->addstr( 13, 0,
		sprintf( "p2: %2.2f, %2.2f", @{ $self->player2->position } ) );
	$self->_window->addstr(
		14, 0,
		sprintf( " b: %2.2f, %2.2f, v: %2.2f, %2.2f",
			$self->ball->position->[0],
			$self->ball->position->[1],
			$self->ball->velocity->[0],
			$self->ball->velocity->[1],
		)
	);
}

1;
