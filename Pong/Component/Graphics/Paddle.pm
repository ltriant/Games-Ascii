package Pong::Component::Graphics::Paddle;

use Moo;
use Pong::Utils qw(round);
extends 'Pong::Component::Graphics';

after update => sub {
	my ($self, $game, $paddle, $win) = @_;

	my ($x, $y) = map round, @{ $paddle->position };
	my ($w, $h) = @{ $paddle->size };

	$win->addstr($y, $x * 1, "=" x ($w * 1));
	$win->refresh;
};

1;

