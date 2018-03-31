package Pong;

use warnings;
use strict;

use Type::Library -base;
use Type::Utils -all;
use Types::Standard qw/Int HashRef/;

declare 'Scoreboard' =>
	as HashRef[Int];

class_type 'Paddle' =>
	{ class => 'Pong::Object::Paddle' };

class_type 'Ball' =>
	{ class => 'Pong::Object::Ball' };

1;
