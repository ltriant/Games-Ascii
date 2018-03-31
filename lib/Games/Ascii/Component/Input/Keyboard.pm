package Games::Ascii::Component::Input::Keyboard;

use Moo;
extends 'Games::Ascii::Component::Input';

sub update {
	my ($self, $game, $object, $key) = @_;

	#printf "    %s got input: %s\n", ref($object), $key;

	my ($vx, $vy) = @{ $object->velocity };

	if ($self->left and (uc $key eq $self->left)) {
		$object->velocity->[0] = $vx - 1;
	}

	if ($self->right and (uc $key eq $self->right)) {
		$object->velocity->[0] = $vx + 1;
	}

	if ($self->up and (uc $key eq $self->up)) {
		$object->velocity->[1] = $vy - 1;
	}

	if ($self->down and (uc $key eq $self->down)) {
		$object->velocity->[1] = $vy + 1;
	}
}

1;
