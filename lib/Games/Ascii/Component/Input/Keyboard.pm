package Games::Ascii::Component::Input::Keyboard;

use v5.42;
use feature 'signatures';

use Moo;
extends 'Games::Ascii::Component::Input';

sub update($self, $game, $object, $key) {
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

  if ($self->quit and (uc $key eq $self->quit)) {
    $game->notify({ quit => 1 });
  }
}

1;
