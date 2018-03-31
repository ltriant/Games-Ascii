package Games::Ascii::Component::Input::Keyboard;

use Moo;
extends 'Games::Ascii::Component::Input';

sub update {
	my ($self, $game, $paddle, $key) = @_;

	#printf "    %s got input: %s\n", ref($paddle), $key;

	my ($vx, $vy) = @{ $paddle->velocity };

	if ($self->left and (uc $key eq $self->left)) {
		$paddle->velocity->[0] = $vx - 1;
	}

	if ($self->right and (uc $key eq $self->right)) {
		$paddle->velocity->[0] = $vx + 1;
	}

	if ($self->up and (uc $key eq $self->up)) {
		$paddle->velocity->[1] = $vy + 1;
	}

	if ($self->down and (uc $key eq $self->down)) {
		$paddle->velocity->[1] = $vy - 1;
	}
}

1;
