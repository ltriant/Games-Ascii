package Roguelike::Object::Wanderer;

use v5.42;
use feature 'signatures';

use Moo;
use Games::Ascii::Utils qw(round min max);

extends 'Games::Ascii::Object';
with 'Games::Ascii::Component::Observable';

has '+size' => (default => sub { [ qw(1 1) ] });

sub move($self, $game, $wanderer, $win) {
	my ($x, $y) = @{ $wanderer->position };
	my ($w, $h) = @{ $wanderer->size };
	my ($vx, $vy) = @{ $wanderer->velocity };
  my ($nx, $ny) = ($x + $vx, $y + $vy);

  if ($game->scene->can_visit($nx, $ny)) {
    $wanderer->position( [ $nx, $ny ]);
    $self->notify( { move => $wanderer->position } );

    foreach my $i (0 .. $#{ $game->_objects }) {
      my $object = $game->_objects->[$i];
      my ($ox, $oy) = @{ $object->position };

      if ($ox == $nx and $oy == $ny) {
        # This may mutate the array we're iterating over, but that would only
        # matter if we collide with two objects on the same tile.
        $self->notify( { pick_up => $i } );
      }
    }
  }


	$wanderer->velocity->[0] = 0;
	$wanderer->velocity->[1] = 0;
}

sub draw($self, $game, $wanderer, $win) {
  my ($wx, $wy) = @{ $wanderer->position };
  my ($vp_x_lo, undef) = $game->viewport->x_range_incl();
  my ($vp_y_lo, undef) = $game->viewport->y_range_incl();
  my ($viewport_x, $viewport_y) = @{ $game->level->position };

  $win->attron(Curses::COLOR_PAIR(4));
  $win->addch(
    $viewport_y + $wy - $vp_y_lo,
    $viewport_x + $wx - $vp_x_lo,
    '@',
  );
  $win->attroff(Curses::COLOR_PAIR(4));
};

1;
