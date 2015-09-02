package Pong::Component::Physics::Paddle;

use Moo;
extends 'Pong::Component::Physics';

sub update {
	my ($self, $game, $paddle) = @_;

	my ($x, $y) = @{ $paddle->position };
	my ($w, $h) = @{ $paddle->size };

	if (($x <= 0) and ($paddle->velocity < 0)) {
		# do nothing
	}
	elsif (    ($x + $w >= $game->size->[0])
		and ($paddle->velocity > 0))
	{
		# do nothing
	}
	else {
		$paddle->position->[0] += $paddle->velocity;
	}

	$paddle->velocity(0);
}

1;
