package Pong::Component::Graphics;

use Moo::Role;
use Pong::Utils qw(round);

requires 'draw';

sub clear {
	my ($self, $game, $object, $win) = @_;

	my ($x, $y) = map round, @{ $object->position };
	my ($w, $h) = @{ $object->size };
	my ($gw, $gh) = @{ $game->size };

	$win->hline($gh - $y, $x, ' ', $w);
}

1;
