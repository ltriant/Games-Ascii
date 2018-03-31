#!/usr/bin/env perl

use warnings;
use strict;

use Roguelike::Game;
use Roguelike::Object::Wanderer;

use Games::Ascii::Component::Input::Keyboard;

my $game = Roguelike::Game->new(
	size     => [ 10, 10 ],
	wanderer => Roguelike::Object::Wanderer->new(
		input => Games::Ascii::Component::Input::Keyboard->new(
			left  => 'H',
			down  => 'J',
			up    => 'K',
			right => 'L',
		)),
);

$game->loop;
