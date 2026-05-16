package Roguelike::Game;

use v5.42;
use feature 'signatures';

use Moo;
use Curses;
use Types::Standard qw(Int);

use Games::Ascii qw(Size Viewport);
use Games::Ascii::Viewport;
use Games::Ascii::Utils qw(min max curses_colors round);
use Roguelike qw(Level);

with qw(
  Games::Ascii::Loop
  Games::Ascii::Component::Observable
);

# The size of the game, including the level, HUD, etc.
has size => (
  is       => 'ro',
  isa      => Size,
  required => 1,
);

# The size of the viewport into the level map
has viewport => (
  is      => 'ro',
  isa     => Viewport,
  default => sub {
    Games::Ascii::Viewport->new(size => [qw(50 20)])
  },
);

has level => (
  is       => 'ro',
  isa      => Level,
  required => 1,
);

has points => (
  is      => 'rw',
  isa     => Int,
  default => sub { 0 },
);

sub BUILD($self, $) {
  Curses::start_color();

  # Walkable tiles
  Curses::init_color(Curses::COLOR_BLACK, curses_colors(11, 31, 42));
  Curses::init_pair(1, Curses::COLOR_BLACK, Curses::COLOR_BLACK);

  # Non-walkable tiles
  Curses::init_color(Curses::COLOR_RED, curses_colors(18, 69, 58));
  Curses::init_pair(2, Curses::COLOR_BLACK, Curses::COLOR_RED);
  Curses::init_color(Curses::COLOR_YELLOW, curses_colors(20, 96, 74));
  Curses::init_pair(3, Curses::COLOR_BLACK, Curses::COLOR_YELLOW);

  # Wanderer
  Curses::init_color(Curses::COLOR_MAGENTA, curses_colors(233, 242, 241));
  Curses::init_pair(4, Curses::COLOR_MAGENTA, Curses::COLOR_BLACK);

  # Items
  Curses::init_color(Curses::COLOR_GREEN, curses_colors(167, 198, 193));
  Curses::init_pair(5, Curses::COLOR_GREEN, Curses::COLOR_BLACK);

  # HUD
  Curses::init_pair(6, Curses::COLOR_BLACK, Curses::COLOR_GREEN);

  # Clear the screen on startup
  $self->_window->clear;
  
  # Load the level objects, items, and assets into the game state
  $self->level->load_into($self);

  $self->viewport->move_viewport($self->level, $self->level->wanderer->position);

  # Listen for messages
  $self->push_observer(\&on_notify, $self);
  $self->level->wanderer->push_observer(\&wanderer_notify, $self);
}

sub on_notify($self, $message) {
  if (exists $message->{quit}) {
    $self->graceful_shutdown();
  }
}

sub wanderer_notify($self, $message) {
  if (my $object_idx = $message->{pick_up}) {
    my $object = $self->_objects->[$object_idx];
    $self->handle_collision($object);
    $self->remove_object($object_idx);
  } elsif (my $pos = $message->{move}) {
    # The viewport is centered on the wanderer's position
    $self->viewport->move_viewport($self->level, $pos);
  }
}

sub handle_collision($self, $object) {
  if ($object->kind eq 'gold') {
    $self->points($self->points + 10);
  }
}

sub tick($self) {
  my ($vp_w, $vp_h) = @{ $self->viewport->size };

  $self->_window->attron(Curses::COLOR_PAIR(6));

  my $rand_bump = 0;

  my $time = time();

  # L
  $rand_bump = round((sin($time + 1) / 2.0) + 0.5);
  $self->_window->addstr($rand_bump + 1, 8, "  ");
  $self->_window->addstr($rand_bump + 2, 8, "  ");
  $self->_window->addstr($rand_bump + 3, 8, "    ");

  # O
  $rand_bump = round((sin($time + 3) / 2.0) + 0.5);
  $self->_window->addstr($rand_bump + 1, 13,  "    ");
  $self->_window->addstr($rand_bump + 2, 13,  "  ");
  $self->_window->addstr($rand_bump + 2, 16, " ");
  $self->_window->addstr($rand_bump + 3, 13,  "    ");

  # O
  $rand_bump = round((sin($time + 1) / 2.0) + 0.5);
  $self->_window->addstr($rand_bump + 1, 18, "    ");
  $self->_window->addstr($rand_bump + 2, 18, "  ");
  $self->_window->addstr($rand_bump + 2, 21, " ");
  $self->_window->addstr($rand_bump + 3, 18, "    ");

  # T
  $rand_bump = round((sin($time + 1) / 2.0) + 0.5);
  $self->_window->addstr($rand_bump + 1, 23, "    ");
  $self->_window->addstr($rand_bump + 2, 24, "  ");
  $self->_window->addstr($rand_bump + 3, 24, "  ");

  # G
  $rand_bump = round((sin($time + 5) / 2.0) + 0.5);
  $self->_window->addstr($rand_bump + 5, 11, "   ");
  $self->_window->addstr($rand_bump + 6, 11, "  ");
  $self->_window->addstr($rand_bump + 6, 14, " ");
  $self->_window->addstr($rand_bump + 7, 11, "    ");

  # O
  $rand_bump = round((sin($time + 3) / 2.0) + 0.5);
  $self->_window->addstr($rand_bump + 5, 16, "    ");
  $self->_window->addstr($rand_bump + 6, 16, "  ");
  $self->_window->addstr($rand_bump + 6, 19, " ");
  $self->_window->addstr($rand_bump + 7, 16, "    ");

  # B
  $rand_bump = round((sin($time + 2) / 2.0) + 0.5);
  $self->_window->addstr($rand_bump + 5, 21, "  ");
  $self->_window->addstr($rand_bump + 6, 21, "    ");
  $self->_window->addstr($rand_bump + 7, 21, "    ");

  # L
  $rand_bump = round((sin($time + 3) / 2.0) + 0.5);
  $self->_window->addstr($rand_bump + 5, 26, "  ");
  $self->_window->addstr($rand_bump + 6, 26, "  ");
  $self->_window->addstr($rand_bump + 7, 26, "    ");

  # I
  $rand_bump = round((sin($time + 1) / 2.0) + 0.5);
  $self->_window->addstr($rand_bump + 5, 31, "    ");
  $self->_window->addstr($rand_bump + 6, 32, "  ");
  $self->_window->addstr($rand_bump + 7, 31, "    ");

  # N
  $rand_bump = round((sin($time + 7) / 2.0) + 0.5);
  $self->_window->addstr($rand_bump + 5, 36, "    ");
  $self->_window->addstr($rand_bump + 6, 36, "  ");
  $self->_window->addstr($rand_bump + 6, 39, " ");
  $self->_window->addstr($rand_bump + 7, 36, "  ");
  $self->_window->addstr($rand_bump + 7, 39, " ");

  $self->_window->addstr($self->level->position->[1] + 2, $vp_w + 2 + 2, sprintf(" pts: %-4d", $self->points));
  $self->_window->addstr($self->level->position->[1] + 3, $vp_w + 2 + 2, ' ' x 10);
  $self->_window->addstr($self->level->position->[1] + 4, $vp_w + 2 + 2, ' ' x 10);
  $self->_window->addstr($self->level->position->[1] + 5, $vp_w + 2 + 2, ' ' x 10);
 
  $self->_window->attroff(Curses::COLOR_PAIR(6));

  $self->_window->addstr($self->level->position->[1] + $vp_h + 8, 0, "");
}

1;
