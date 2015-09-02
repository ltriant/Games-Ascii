#!/usr/bin/env perl

use warnings;
use strict;

use Pong::Game;
use Pong::Object::Ball;
use Pong::Object::Paddle;

use Pong::Component::Physics::Ball;

my $game = Pong::Game->new(
	size    => [ 10, 10 ],
	player1 => Pong::Object::Paddle->new,
	player2 => Pong::Object::Paddle->new,
	ball    => Pong::Object::Ball->new,
);

$game->loop;
