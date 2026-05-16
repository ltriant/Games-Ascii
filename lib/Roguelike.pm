package Roguelike;

use Type::Library -base;
use Type::Utils -all;
use Types::Standard qw(Str);

class_type 'Wanderer' =>
	{ class => 'Roguelike::Object::Wanderer' };

class_type 'Item' =>
	{ class => 'Roguelike::Object::Item' };

class_type 'Level' =>
	{ class => 'Roguelike::Level' };

class_type 'Tile' =>
  { class => 'Roguelike::Level::Tile' };

class_type 'RectangleRoom' =>
  { class => 'Roguelike::Level::RectangleRoom' };

enum 'ItemKind' =>
  [qw/gold/];

1;
