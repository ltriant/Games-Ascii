package Pong::Component::Physics::Paddle;

use Moo;
extends 'Pong::Component::Physics';

sub update {
	my ($self, $game, $paddle) = @_;

	my ($x, $y) = @{ $paddle->position };
	my ($w, $h) = @{ $paddle->size };

	my $v = $paddle->velocity;

	if ($x + $v < 0) {
		$paddle->position->[0] = 0;
	}
	elsif ($x + $w + $v >= $game->size->[0]) {
		$paddle->position->[0] = $game->size->[0] - $w;
	}
	else {
		$paddle->position->[0] += $paddle->velocity;
	}

	$paddle->velocity(0);
}

1;
