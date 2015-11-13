#!/usr/bin/env perl

use warnings;
use strict;

use Pong::Game;
use Pong::Object::Ball;
use Pong::Object::Paddle;

use Pong::Component::Input::Keyboard;

my $game = Pong::Game->new(
	size    => [ 10, 10 ],
	ball    => Pong::Object::Ball->new,
	player1 => Pong::Object::Paddle->new(
		input => Pong::Component::Input::Keyboard->new(
			left  => 'A',
			right => 'S'
		)),
	player2 => Pong::Object::Paddle->new(
		input => Pong::Component::Input::Keyboard->new(
			left  => 'K',
			right => 'L'
		)),
);

$game->loop;
