package Games::Ascii::Viewport;

use v5.42;
use feature 'signatures';

use Moo;
use Games::Ascii qw(Size Position);

has size => (
  is       => 'ro',
  isa      => Size,
  required => 1,
);

has position => (
  is  => 'rw',
  isa => Position,
);

sub x_range_incl($self) {
  my ($x, undef) = @{ $self->position };
  my ($w, undef) = @{ $self->size };
  return ($x, $x + $w - 1);
}

sub y_range_incl($self) {
  my (undef, $y) = @{ $self->position };
  my (undef, $h) = @{ $self->size };
  return ($y, $y + $h - 1);
}

# Reposition the viewport within the world coordinates around an origin.
sub move_viewport($self, $world, $origin) {
  my ($origin_x, $origin_y) = @$origin;
  my ($vw, $vh) = @{ $self->size };

  my $tmp_lo_x = $origin_x - ($vw / 2);
  my $tmp_hi_x = $origin_x + ($vw / 2);
  my $lo_x = 0;
  if ($tmp_lo_x < 0) {
    $lo_x = 0;
  } elsif ($tmp_hi_x > ($world->size->[0] - 1)) {
    $lo_x = $world->size->[0] - $vw;
  } else {
    $lo_x = $tmp_lo_x;
  }

  my $tmp_lo_y = $origin_y - ($vh / 2);
  my $tmp_hi_y = $origin_y + ($vh / 2);
  my $lo_y = 0;
  if ($tmp_lo_y < 0) {
    $lo_y = 0;
  } elsif ($tmp_hi_y > ($world->size->[1] - 1)) {
    $lo_y = $world->size->[1] - $vh;
  } else {
    $lo_y = $tmp_lo_y;
  }

  $self->position( [ $lo_x, $lo_y ] );
}

1;
