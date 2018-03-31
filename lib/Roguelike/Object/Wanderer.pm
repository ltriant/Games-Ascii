package Roguelike::Object::Wanderer;

use warnings;
use strict;

use Moo;
extends 'Games::Ascii::Object';

use Games::Ascii::Utils qw/round/;

has '+size' => (default => sub { [ qw/1 1/ ] });

sub move {
	my ($self, $game, $wanderer) = @_;

	my ($x, $y) = @{ $wanderer->position };
	my ($w, $h) = @{ $wanderer->size };

	my ($vx, $vy) = @{ $wanderer->velocity };

	if ($x + $vx < 0) {
		$wanderer->position->[0] = 0;
	}
	elsif ($x + $w + $vx >= $game->size->[0]) {
		$wanderer->position->[0] = $game->size->[0] - $w;
	}
	else {
		$wanderer->position->[0] += $vx;
	}

	if ($y + $vy < 0) {
		$wanderer->position->[1] = 0;
	}
	elsif ($y + $w + $vy >= $game->size->[0]) {
		$wanderer->position->[1] = $game->size->[1] - $w;
	}
	else {
		$wanderer->position->[1] += $vy;
	}

	$wanderer->velocity->[0] = 0;
	$wanderer->velocity->[1] = 0;
}

sub draw {
	my ($self, $game, $wanderer, $win) = @_;

	my ($x, $y) = map round, @{ $wanderer->position };
	my ($gw, $gh) = @{ $game->size };

	$win->addch($y, $x, '@');
};

1;
