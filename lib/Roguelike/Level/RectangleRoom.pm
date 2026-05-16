package Roguelike::Level::RectangleRoom;

use v5.42;
use feature 'signatures';

use Moo;
use Types::Standard qw(Int);
use Games::Ascii qw(Position);

has position => (is => 'ro', isa => Position);
has width => (is => 'ro', isa => Int);
has height => (is => 'ro', isa => Int);

has _bottom_right => (is => 'rw', isa => Position);
has center => (is => 'rw', isa => Position);

sub BUILD($self, $) {
  my ($x, $y) = @{ $self->position };
  my ($x2, $y2) = ($x + $self->width, $y + $self->height);
  $self->_bottom_right([ $x2, $y2 ]);
  $self->center([
    int(($x + $x2) / 2),
    int(($y + $y2) / 2)
  ]);
}

# Does this room intersect with another room?
sub intersects($self, $room) {
  my ($x1, $y1) = @{ $self->position };
  my ($x2, $y2) = @{ $self->_bottom_right };

  my ($o_x1, $o_y1) = @{ $room->position };
  my ($o_x2, $o_y2) = @{ $room->_bottom_right };

  ($x1 <= $o_x2) and ($x2 >= $o_x1) and ($y1 <= $o_y2) and ($y2 >= $o_y1)
}

1;

