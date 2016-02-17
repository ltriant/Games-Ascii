package Pong::Component::Observable;

use Moo::Role;
use Types::Standard qw/ArrayRef/;
use Pong qw/Observer/;

has observers => (
	is      => 'rw',
	isa     => ArrayRef[Observer],
	default => sub { [] }
);

sub push_observer {
	my ($self, $obj) = @_;

	unless (grep { $_ eq $obj } @{ $self->observers }) {
		push @{ $self->observers } => $obj;
	}
}

sub notify {
	my ($self, $message) = @_;
	$_->on_notify($message) for @{ $self->observers };
}

1;
