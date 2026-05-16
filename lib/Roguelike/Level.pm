package Roguelike::Level;

use v5.42;
use feature 'signatures';

use Moo;
use Types::Standard qw(ArrayRef);

use Games::Ascii qw(Position Size);
use Games::Ascii::Utils qw(min max);
use Roguelike qw(Wanderer Item Tile);
use Roguelike::Level::Tile;

with 'Games::Ascii::Component::Graphics';

has position => (
  is       => 'ro',
  isa      => Position,
  required => 1,
);

# This is the size of the entire level map
has size => (
  is       => 'ro',
  isa      => Size,
  required => 1,
);

has wanderer => (
  is       => 'ro',
  isa      => Wanderer,
  required => 1,
);

has items => (
  is      => 'rw',
  isa     => ArrayRef[Item],
  default => sub { [] },
);

has _tiles => (
  is  => 'rw',
  isa => ArrayRef[ArrayRef[Tile]],
);

sub BUILD($self, $) {
  my ($width, $height) = @{ $self->size };

  # Initialise the game map with a bunch of unwalkable tiles
  $self->_tiles(
    [ map {
        [ map {
          Roguelike::Level::Tile->new(walkable => 0)
        } 1 .. $width ]
      } 1 .. $height ]
  );
}

sub push_item($self, $item) {
	push @{ $self->items } => $item;
}

sub load_into($self, $game) {
  $game->scene($self);
  $game->push_object($self->wanderer);
  foreach my $item (@{ $self->items }) {
    $game->push_object($item);
  }
}

sub can_visit($self, $x, $y) {
  # Check if in the bounds of the level
  my ($lw, $lh) = @{ $self->size };
  if (($x < 0) or ($y < 0) or ($x >= $lw) or ($y >= $lh)) {
    return 0;
  }

  # Check if the tile is walkable
  $self->_tiles->[$y]->[$x]->walkable
}

sub make_room($self, $room) {
  my ($room_x, $room_y) = @{ $room->position };
  my $room_w = $room->width;
  my $room_h = $room->height;

  foreach my $y ($room_y + 1 .. $room_y + $room_h - 2) {
    foreach my $x ($room_x + 1 .. $room_x + $room_w - 2) {
      $self->_tiles->[$y]->[$x]->set_walkable();
    }
  }
}

sub plot_line_high($self, $pos1, $pos2) {
  my ($x1, $y1) = @$pos1;
  my ($x2, $y2) = @$pos2;

  my ($dx, $dy) = ($x2 - $x1, $y2 - $y1);
  my $xi = 1;
  if ($dx < 0) {
    $xi = -1;
    $dx = -1 * $dx;
  }
  my $d = (2 * $dx) - $dy;
  my $x = $x1;

  foreach my $y ($y1 .. $y2) {
    $self->_tiles->[$y]->[$x]->set_walkable();

    if ($d > 0) {
      $x += $xi;
      $d += 2 * ($dx - $dy);
      $self->_tiles->[$y]->[$x]->set_walkable();
    } else {
      $d += 2 * $dx;
    }
  }
}

sub plot_line_low($self, $pos1, $pos2) {
  my ($x1, $y1) = @$pos1;
  my ($x2, $y2) = @$pos2;

  my ($dx, $dy) = ($x2 - $x1, $y2 - $y1);
  my $yi = 1;
  if ($dy < 0) {
    $yi = -1;
    $dy = -1 * $dy;
  }
  my $d = (2 * $dy) - $dx;
  my $y = $y1;

  foreach my $x ($x1 .. $x2) {
    $self->_tiles->[$y]->[$x]->set_walkable();

    if ($d > 0) {
      $y += $yi;
      $d += 2 * ($dy - $dx);
      $self->_tiles->[$y]->[$x]->set_walkable();
    } else {
      $d += 2 * $dy;
    }
  }
}

# Make a line between two points.
# https://en.wikipedia.org/wiki/Bresenham%27s_line_algorithm#Algorithm_for_integer_arithmetic
sub make_path($self, $pos1, $pos2) {
  my ($x1, $y1) = @$pos1;
  my ($x2, $y2) = @$pos2;

  if (abs($y2 - $y1) < abs($x2 - $x1)) {
    if ($x1 > $x2) {
      $self->plot_line_low($pos2, $pos1);
    } else {
      $self->plot_line_low($pos1, $pos2);
    }
  } else {
    if ($y1 > $y2) {
      $self->plot_line_high($pos2, $pos1);
    } else {
      $self->plot_line_high($pos1, $pos2);
    }
  }
}

sub draw($self, $game, $win) {
  my ($vp_x_lo, $vp_x_hi) = $game->viewport->x_range_incl();
  my ($vp_y_lo, $vp_y_hi) = $game->viewport->y_range_incl();
  my ($viewport_x, $viewport_y) = @{ $game->level->position };

  foreach my $y ($vp_y_lo .. $vp_y_hi) {
    foreach my $x ($vp_x_lo .. $vp_x_hi) {
      my $tile = $self->_tiles->[$y]->[$x];
      $win->attron(Curses::COLOR_PAIR($tile->color_pair));
      $win->addch(
        $viewport_y + $y - $vp_y_lo,
        $viewport_x + $x - $vp_x_lo,
        ' ',
      );
      $win->attroff(Curses::COLOR_PAIR($tile->color_pair));
    }
  }
}

1;
