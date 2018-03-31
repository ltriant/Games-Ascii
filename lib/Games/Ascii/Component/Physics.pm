package Games::Ascii::Component::Physics;

use Moo::Role;
use Games::Ascii qw(
	Velocity
);

requires 'move';

has velocity => (
	is      => 'rw',
	isa     => Velocity,
	default => sub { [ 0, 0 ] },
);

1;
