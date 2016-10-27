package Pong::Object::Ball;

use Moo;
use Pong::Utils qw(round);

use Const::Fast;

extends 'Pong::Object';
with 'Pong::Component::Observable';

has '+size' => (default => sub { [ qw/1 1/ ] });

const my $MAX_VELOCITY => 1.00;

sub move {
	my ($self, $game, $ball) = @_;

	my ($x, $y) = @{ $ball->position };
	my ($vx, $vy) = @{ $ball->velocity };

	my ($nx, $ny) = ($x + $vx, $y + $vy);

	my @messages;

	foreach my $obj ($game->player1, $game->player2) {
		my ($ox, $oy) = @{ $obj->position };
		my ($sz_x, $sz_y) = @{ $obj->size };

		# If the ball is about to move into the object's boundaries, it's a
		# collision
		if (    ($nx >= $ox)
			and ($nx <= ($ox + $sz_x))
			and ($ny >= $oy)
			and ($ny <= ($oy + $sz_y))
		) {
			$vy *= -1;
		}
	}

	if ($ny <= 0) {
		# If we're hitting the top, player 1 scored
		$vy *= -1;
		push @messages => { score => $game->player1 };
	}
	elsif ($ny >= $game->size->[1]) {
		# If we're hitting the bottom, player 2 scored
		$vy *= -1;
		push @messages => { score => $game->player2 };
	}

	if ($nx <= 0) {
		# If we're hitting the left wall, bounce off
		$vx *= -1;
	}
	elsif ($nx >= $game->size->[0]) {
		# If we're hitting the right wall, bounce off
		$vx *= -1;
	}

	# Cap the X-velocity
	if (abs($vx) > $MAX_VELOCITY) {
		if ($vx < 0) {
			$vx = 0 - $MAX_VELOCITY;
		}
		else {
			$vx = $MAX_VELOCITY;
		}
	}

	$ball->position->[0] = $nx;
	$ball->position->[1] = $ny;
	$ball->velocity->[0] = $vx;
	$ball->velocity->[1] = $vy;

	$self->notify($_) for @messages;
}

sub draw {
	my ($self, $game, $ball, $win) = @_;

	my ($x, $y) = map round, @{ $ball->position };
	my ($w, $h) = @{ $ball->size };
	my ($gw, $gh) = @{ $game->size };

	$win->addstr($y, $x, "o");
}

1;
