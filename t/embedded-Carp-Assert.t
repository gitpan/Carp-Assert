#!/usr/local/bin/perl -w

use Test::More no_plan;

# From line 102
use Carp::Assert;


# From line 186
my $life = 'Whimper!';
ok( eval { assert( $life =~ /!$/ ); 1 },   'life ends with a bang' );


# From line 206
{
  package Some::Other;
  no Carp::Assert;
  ::ok( eval { assert(0) if DEBUG; 1 } );
}


# From line 217
ok( eval { assert(1); 1 } );
ok( !eval { assert(0); 1 } );


# From line 227
eval { assert(0) };
like( $@, qr/^Assertion failed!/,       'error format' );
like( $@, qr/Carp::Assert::assert\(0\) called at/,      '  with stack trace' );


# From line 242
eval { assert( Dogs->isa('People'), 'Dogs are people, too!' ); };
like( $@, qr/^Assertion \(Dogs are people, too!\) failed!/, 'names' );


# From line 269
eval q{
  my $example = sub {
    no warnings;
    
    affirm {
        my $customer = Customer->new($customerid);
        my @cards = $customer->credit_cards;
        grep { $_->is_active } @cards;
    } "Our customer has an active credit card";

;
  }
};
is($@, '', "example from line 269");

