package Pong::Component::Input::Keyboard;

use Moo;
extends 'Pong::Component::Input';

sub update {
	my ($self, $game, $object, $key) = @_;

	printf "    %s got input: %s\n", ref($object), $key;

	if (uc $key eq 'H') {
		$object->velocity($object->velocity - 1);
	}

	if (uc $key eq 'L') {
		$object->velocity($object->velocity + 1);
	}
}

1;
