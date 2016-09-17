package Pong::Object::Ball;

use Moo;
use Pong::Utils qw(round);

extends 'Pong::Object';
with 'Pong::Component::Observable';

has '+size' => (default => sub { [ qw/1 1/ ] } );

sub move {
	my ($self, $game, $ball) = @_;

	my ($x, $y) = @{ $ball->position };
	my ($vx, $vy) = @{ $ball->velocity };

	my ($nx, $ny) = ($x + $vx, $y + $vy);

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

	# If we're hitting the top, player 1 scored
	if ($ny <= 0) {
		#$vy *= -1;
		$self->notify( { score => $game->player1 } );
		return;
	}

	# If we're hitting the bottom, player 2 scored
	if ($ny >= $game->size->[1]) {
		#$vy *= -1;
		$self->notify( { score => $game->player2 } );
		return;
	}

	# If we're hitting the left wall, bounce off
	if ($nx <= 0) {
		$vx *= -1;
	}

	# If we're hitting the right wall, bounce off
	if ($nx >= $game->size->[0]) {
		$vx *= -1;
	}

	$ball->position->[0] = $nx;
	$ball->position->[1] = $ny;
	$ball->velocity->[0] = $vx;
	$ball->velocity->[1] = $vy;
}

sub draw {
	my ($self, $game, $ball, $win) = @_;

	my ($x, $y) = map round, @{ $ball->position };
	my ($w, $h) = @{ $ball->size };
	my ($gw, $gh) = @{ $game->size };

	$win->addstr($gh - $y, $x, "o");
}

1;
