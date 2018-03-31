package Games::Ascii::Component::Graphics;

use Moo::Role;
use Games::Ascii::Utils qw(round);

requires 'draw';

sub clear {
	my ($self, $game, $object, $win) = @_;

	my ($x, $y) = map round, @{ $object->position };
	my ($w, $h) = @{ $object->size };
	my ($gw, $gh) = @{ $game->size };

	for (0 .. $h - 1) {
		$win->hline($y + $_, $x, ' ', $w);
	}
}

1;
