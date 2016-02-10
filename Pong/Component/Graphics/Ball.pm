package Pong::Component::Graphics::Ball;

use Moo;
use Pong::Utils qw(round);
extends 'Pong::Component::Graphics';

after update => sub {
	my ($self, $game, $ball, $win) = @_;

	my ($x, $y) = map round, @{ $ball->position };
	my ($w, $h) = @{ $ball->size };

	$win->addstr($y, $x * 1, "*" x ($w * 1));
	$win->refresh;
};

1;
