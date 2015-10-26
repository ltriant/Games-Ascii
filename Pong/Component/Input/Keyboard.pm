package Pong::Component::Input::Keyboard;

use Moo;
extends 'Pong::Component::Input';

sub update {
	my ($self, $paddle, $key) = @_;

	printf "    %s got input: %s\n", ref($paddle), $key;

	if (uc $key eq 'H') {
		$paddle->velocity($paddle->velocity - 1);
	}

	if (uc $key eq 'L') {
		$paddle->velocity($paddle->velocity + 1);
	}
}

1;
