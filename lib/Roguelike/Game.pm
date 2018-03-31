package Roguelike::Game;

use Moo;
use Games::Ascii qw/Size/;
use Roguelike qw/Wanderer/;

with 'Games::Ascii::Loop';

has wanderer => ( is => 'ro', isa => Wanderer, required => 1 );
has size     => ( is => 'ro', isa => Size,     required => 1 );

sub BUILD {
	my ($self) = @_;
	$self->wanderer->position( [2, 2] );
	$self->push_object($self->wanderer);
	$self->_window->clear;
}

sub tick {
	my ($self) = @_;
	$self->_window->addstr(10, 10, "hjkl to move");
}

1;
