package Roguelike::Object::Item;

use v5.42;
use feature 'signatures';

use Moo;
use Types::Standard qw(Str);
use Roguelike qw(ItemKind);

use Games::Ascii::Utils qw(round min max);
extends 'Games::Ascii::Object';

has '+size' => (default => sub { [ qw(1 1) ] });

has kind => (
  is       => 'ro',
  isa      => ItemKind,
  required => 1,
);

my %item_sigil_dispatch = (
  gold => '$'
);

sub sigil($self) {
  return $item_sigil_dispatch{$self->kind};
}

sub draw($self, $game, $item, $win) {
  my ($x, $y) = @{ $item->position };
  my ($vp_x_lo, $vp_x_hi) = $game->viewport->x_range_incl();
  my ($vp_y_lo, $vp_y_hi) = $game->viewport->y_range_incl();
  my ($viewport_x, $viewport_y) = @{ $game->level->position };

  if (($x < $vp_x_lo) or ($x > $vp_x_hi) or ($y < $vp_y_lo) or ($y > $vp_y_hi)) {
    return;
  }

  $win->attron(Curses::COLOR_PAIR(5));
  $win->addch(
    $viewport_y + $y - $vp_y_lo,
    $viewport_x + $x - $vp_x_lo,
    $self->sigil(),
  );
  $win->attroff(Curses::COLOR_PAIR(5));
}

1;
