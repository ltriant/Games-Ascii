package Pong::Object::Paddle;

use Moo;
extends 'Games::Ascii::Object';

use Games::Ascii::Utils qw(round);

# position is the left edge of the paddle
has '+size' => (default => sub { [ qw/3 1/ ] });

sub move {
	my ($self, $game, $paddle) = @_;

	my ($x, $y) = @{ $paddle->position };
	my ($w, $h) = @{ $paddle->size };

	my ($vx, undef) = @{ $paddle->velocity };

	if ($x + $vx < 0) {
		$paddle->position->[0] = 0;
	}
	elsif ($x + $w + $vx >= $game->size->[0]) {
		$paddle->position->[0] = $game->size->[0] - $w;
	}
	else {
		$paddle->position->[0] += $vx;
	}

	$paddle->velocity->[0] = 0;
}

sub draw {
	my ($self, $game, $paddle, $win) = @_;

	my ($x, $y) = map round, @{ $paddle->position };
	my ($w, $h) = @{ $paddle->size };
	my ($gw, $gh) = @{ $game->size };

	$win->hline($y, $x, '-', $w);
};

1;
