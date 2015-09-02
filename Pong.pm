package Pong;

use Type::Library -base;
use Type::Utils -all;
use Types::Standard qw/Tuple Int Enum Num/;

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

class_type 'InputComponent' =>
	{ class => 'Pong::Component' };

class_type 'PhysicsComponent' =>
	{ class => 'Pong::Component::Physics' };

class_type 'GraphicsComponent' =>
	{ class => 'Pong::Component::Graphics' };

class_type 'Paddle' =>
	{ class => 'Pong::Object::Paddle' };

class_type 'Ball' =>
	{ class => 'Pong::Object::Ball' };

1;
