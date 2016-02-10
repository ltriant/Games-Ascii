package Pong::Object::Paddle;

use Moo;
extends 'Pong::Object';
with qw(
	Pong::Component::Physics
	Pong::Component::Graphics
);

use Pong::Utils qw(round);

# position is the left edge of the paddle
has '+size'     => (default => sub { [ qw/3 1/ ] } );
has '+velocity' => (default => sub { 0 } );

sub move {
	my ($self, $game, $paddle) = @_;

	my ($x, $y) = @{ $paddle->position };
	my ($w, $h) = @{ $paddle->size };

	my $v = $paddle->velocity;

	if ($x + $v < 0) {
		$paddle->position->[0] = 0;
	}
	elsif ($x + $w + $v >= $game->size->[0]) {
		$paddle->position->[0] = $game->size->[0] - $w;
	}
	else {
		$paddle->position->[0] += $paddle->velocity;
	}

	$paddle->velocity(0);
}

sub draw {
	my ($self, $game, $paddle, $win) = @_;

	my ($x, $y) = map round, @{ $paddle->position };
	my ($w, $h) = @{ $paddle->size };

	$win->addstr($y, $x * 1, "=" x ($w * 1));
	$win->refresh;
};

1;
