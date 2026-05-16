#!/usr/bin/env perl

use v5.42;

use Roguelike::Game;
use Roguelike::Object::Wanderer;
use Roguelike::Level::Generated;

use Games::Ascii::Component::Input::Keyboard;

my $game = Roguelike::Game->new(
	size   => [ 60, 30 ],
  level  => Roguelike::Level::Generated->new(
    size     => [ 100, 100 ],
    position => [ 2, 10 ],
    wanderer => Roguelike::Object::Wanderer->new(
      input => Games::Ascii::Component::Input::Keyboard->new(
        up    => 'W',
        left  => 'A',
        down  => 'S',
        right => 'D',
        quit  => 'Q',
      )),
  ),
);

$game->loop;
