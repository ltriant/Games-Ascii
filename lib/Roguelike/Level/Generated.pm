package Roguelike::Level::Generated;

use v5.42;
use feature 'signatures';

use Moo;
extends 'Roguelike::Level';

use Games::Ascii::Utils qw(rand_int);
use Roguelike::Level::RectangleRoom;
use Roguelike::Object::Item;

use Const::Fast;

const my $ROOM_MIN_SIZE => 8;
const my $ROOM_MAX_SIZE => 20;
const my $NUM_ROOMS => 10;

sub BUILD($self, $) {
  # Fairly stupid procedural generator for the dungeon
  my @rooms;
  while (@rooms < $NUM_ROOMS) {
    my $room_width = rand_int($ROOM_MIN_SIZE, $ROOM_MAX_SIZE);
    my $room_height = rand_int($ROOM_MIN_SIZE, $ROOM_MAX_SIZE);

    my $x = rand_int(0, $self->size->[0] - $room_width  - 1);
    my $y = rand_int(0, $self->size->[1] - $room_height - 1);

    my $room = Roguelike::Level::RectangleRoom->new(
      position => [ $x, $y ],
      width    => $room_width,
      height   => $room_height,
    );

    next if grep { $room->intersects($_) } @rooms;

    $self->make_room($room);

    if (@rooms == 0) {
      $self->wanderer->position($room->center);

      # TODO randomise the gold drops
      $self->push_item(Roguelike::Object::Item->new(
        kind     => 'gold',
        position => [ $room->center->[0] + 2, $room->center->[1] + 2 ])
      );
    } else {
      my $last_room = $rooms[$#rooms];
      $self->make_path($room->center, $last_room->center);
    }

    push @rooms => $room;
  }
}

1;
