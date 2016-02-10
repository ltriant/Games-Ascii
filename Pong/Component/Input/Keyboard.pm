package Pong::Component::Input::Keyboard;

use Moo;
extends 'Pong::Component::Input';

sub update {
	my ($self, $game, $paddle, $key) = @_;

	#printf "    %s got input: %s\n", ref($paddle), $key;

	if (uc $key eq $self->left) {
		$paddle->velocity($paddle->velocity - 1);
	}

	if (uc $key eq $self->right) {
		$paddle->velocity($paddle->velocity + 1);
	}
}

1;
