package Pong::Object::Ball;

use Moo;
use Pong::Utils qw(round);

extends 'Pong::Object';
with 'Pong::Component::Observable';

has '+size' => (default => sub { [ qw/1 1/ ] } );

sub move {
	my ($self, $game, $ball) = @_;

	my ($x, $y) = @{ $ball->position };
	my ($ew, $ns) = @{ $ball->direction };
	my ($vx, $vy) = @{ $ball->velocity };

	my ($nx, $ny) = ($x + $vx, $y + $vy);

	foreach my $obj ($game->player1, $game->player2) {
		my ($ox, $oy) = @{ $obj->position };
		my ($sz_x, $sz_y) = @{ $obj->size };

		if (    ($nx >= $ox)
			and ($nx <= ($ox + $sz_x))
			and ($ny >= $oy)
			and ($ny <= ($oy + $sz_y))
		) {
#			printf "  Hitting a %s object!\n", ref $obj;
#			printf "    ox, oy: %d, %d\n", $ox, $oy;
#			printf "    sz_x, sz_y: %d, %d\n", $sz_x, $sz_y;
#			printf "    Old direction: %s%s\n", $ns, $ew;

			if ($ns eq 'N') {
				$ns = $ball->direction->[1] = 'S';
			}
			elsif ($ns eq 'S') {
				$ns = $ball->direction->[1] = 'N';
			}

#			printf "    New direction: %s%s\n", $ns, $ew;
		}
	}

	# Hitting a wall? Change direction.
	if (($y <= 0) and ($ns eq 'N')) {
		$ns = $ball->direction->[1] = 'S';
		$self->notify( { score => $game->player1 } );
	}
	if (($y >= $game->size->[1]) and ($ns eq 'S')) {
		$ns = $ball->direction->[1] = 'N';
		$self->notify( { score => $game->player2 } );
	}

	if (($x <= 0) and ($ew eq 'W')) {
		$ew = $ball->direction->[0] = 'E';
	}
	if (($x >= $game->size->[0]) and ($ew eq 'E')) {
		$ew = $ball->direction->[0] = 'W';
	}

	$y = $ball->position->[1] -= $vy if $ns eq 'N';
	$y = $ball->position->[1] += $vy if $ns eq 'S';
	$x = $ball->position->[0] += $vx if $ew eq 'E';
	$x = $ball->position->[0] -= $vx if $ew eq 'W';
}

sub draw {
	my ($self, $game, $ball, $win) = @_;

	my ($x, $y) = map round, @{ $ball->position };
	my ($w, $h) = @{ $ball->size };
	my ($gw, $gh) = @{ $game->size };

	$win->addstr($gh - $y, $x, "o");
}

1;
