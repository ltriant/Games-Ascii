package Pong::Component::Observable;

use Moo::Role;
use Types::Standard qw/ArrayRef CodeRef/;

has observers => (
	is      => 'rw',
	default => sub { [] }
);

sub push_observer {
	my ($self, $fun, @params) = @_;

	unless (grep { $_->[0] eq $fun } @{ $self->observers }) {
		push @{ $self->observers } => [ $fun, @params ];
	}
}

sub notify {
	my ($self, $message) = @_;

	foreach my $observer (@{ $self->observers }) {
		my ($fun, @params) = @$observer;
		$fun->(@params, $message);
	}
}

1;
