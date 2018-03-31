package Roguelike;

use warnings;
use strict;

use Type::Library -base;
use Type::Utils -all;

class_type 'Wanderer' =>
	{ class => 'Roguelike::Object::Wanderer' };

1;
