package Pong::Component::Input::Keyboard;

use Moo;
extends 'Pong::Component::Input';

sub update {
	my ($self, $game, $paddle, $key) = @_;

	#printf "    %s got input: %s\n", ref($paddle), $key;

	my ($vx, $vy) = @{ $paddle->velocity };

	if (uc $key eq $self->left) {
		$paddle->velocity->[0] = $vx - 1;
	}

	if (uc $key eq $self->right) {
		$paddle->velocity->[0] = $vx + 1;
	}
}

1;
