package Roguelike::Level::Tile;

use v5.42;
use feature 'signatures';

use Moo;
use Types::Standard qw(Bool Int);
use Games::Ascii::Utils qw(round);

has walkable => (
  is       => 'rwp',
  isa      => Bool,
  required => 1,
);

has color_pair => (
  is  => 'rwp',
  isa => Int,
  default => sub { 2 + round(rand) },
);

sub set_walkable($self) {
  $self->_set_walkable(1);
  $self->_set_color_pair(1);
};

# TODO can add properties for transparency and darkness (for FOV)

1;
