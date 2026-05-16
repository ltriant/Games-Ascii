package Games::Ascii;

use warnings;
use strict;

use Type::Library -base;
use Type::Utils -all;
use Types::Standard qw/Tuple Int Num StrMatch/;

class_type 'InputComponent' =>
	{ class => 'Games::Ascii::Component::Input' };

class_type 'GraphicsComponent' =>
	{ class => 'Games::Ascii::Component::Graphics' };

class_type 'Object' =>
	{ class => 'Games::Ascii::Object' };

class_type 'Viewport' =>
	{ class => 'Games::Ascii::Viewport' };

declare 'KeyboardChar' =>
	as StrMatch[ qr{^[a-zA-Z]$} ];

declare 'Position' =>
	as Tuple[Int, Int];

declare 'Size' =>
	as Tuple[Int, Int];

declare 'Velocity' =>
	as Tuple[Num, Num];

role_type 'Observer' =>
	{ role => 'Games::Ascii::Component::Observer' };

1;
