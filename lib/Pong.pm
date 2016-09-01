package Pong;

use warnings;
use strict;

use Type::Library -base;
use Type::Utils -all;
use Types::Standard qw/Tuple Int Enum Num StrMatch HashRef/;

declare 'KeyboardChar' =>
	as StrMatch[ qr{^[a-zA-Z]$} ];

declare 'Position' =>
	as Tuple[Int, Int];

declare 'Size' =>
	as Tuple[Int, Int];

declare 'Direction' =>
	as Tuple[
		Enum[qw(E W)],
		Enum[qw(N S)]
	];

declare 'Velocity' =>
	as Num;

declare 'Scoreboard' =>
	as HashRef[Int];

class_type 'InputComponent' =>
	{ class => 'Pong::Component::Input' };

class_type 'Object' =>
	{ class => 'Pong::Object' };

class_type 'Paddle' =>
	{ class => 'Pong::Object::Paddle' };

class_type 'Ball' =>
	{ class => 'Pong::Object::Ball' };

role_type 'Observer' =>
	{ role => 'Pong::Component::Observer' };

1;
