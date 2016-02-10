package Pong::Component::Graphics;

use Moo;
use Pong::Utils qw(round);
extends 'Pong::Component';

sub clear {
	my ($self, $object, $win) = @_;

	my ($x, $y) = map round, @{ $object->position };
	my ($w, $h) = @{ $object->size };

	$win->addstr($y, $x * 1, " " x ($w * 1));
	$win->refresh;
}

sub update {
	my ($self, undef, $object, $win) = @_;
	$self->clear($object, $win);
}

1;
