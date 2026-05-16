package Games::Ascii::Component::Observable;

use v5.42;
use feature 'signatures';

use Moo::Role;
use Types::Standard qw/ArrayRef Any/;

has observers => (
	is      => 'rw',
	isa     => ArrayRef[Any],
	default => sub { [] }
);

sub push_observer($self, $fun, @params) {
	unless (grep { $_->[0] eq $fun } @{ $self->observers }) {
		push @{ $self->observers } => [ $fun, @params ];
	}
}

sub notify($self, $message) {
	foreach my $observer (@{ $self->observers }) {
		my ($fun, @params) = @$observer;
		$fun->(@params, $message);
	}
}

1;
