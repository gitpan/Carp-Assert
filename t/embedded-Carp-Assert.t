#!/usr/bin/perl -w

use Test::More 'no_plan';

package Catch;

sub TIEHANDLE {
    my($class) = shift;
    return bless {}, $class;
}

sub PRINT  {
    my($self) = shift;
    $main::_STDOUT_ .= join '', @_;
}

sub READ {}
sub READLINE {}
sub GETC {}

package main;

local $SIG{__WARN__} = sub { $_STDERR_ .= join '', @_ };
tie *STDOUT, 'Catch' or die $!;


{
#line 115 lib/Carp/Assert.pm
use Carp::Assert;

}

{
#line 207 lib/Carp/Assert.pm
my $life = 'Whimper!';
ok( eval { assert( $life =~ /!$/ ); 1 },   'life ends with a bang' );

}

{
#line 227 lib/Carp/Assert.pm
{
  package Some::Other;
  no Carp::Assert;
  ::ok( eval { assert(0) if DEBUG; 1 } );
}

}

{
#line 238 lib/Carp/Assert.pm
ok( eval { assert(1); 1 } );
ok( !eval { assert(0); 1 } );

}

{
#line 248 lib/Carp/Assert.pm
eval { assert(0) };
like( $@, '/^Assertion failed!/',       'error format' );
like( $@, '/Carp::Assert::assert\(0\) called at/',      '  with stack trace' );

}

{
#line 263 lib/Carp/Assert.pm
eval { assert( Dogs->isa('People'), 'Dogs are people, too!' ); };
like( $@, '/^Assertion \(Dogs are people, too!\) failed!/', 'names' );

}

eval q{
  my $example = sub {
    local $^W = 0;

#line 140 lib/Carp/Assert.pm

    # Take the square root of a number.
    sub my_sqrt {
        my($num) = shift;

        # the square root of a negative number is imaginary.
        assert($num >= 0);

        return sqrt $num;
    }

;

  }
};
is($@, '', "example from line 140");

{
#line 140 lib/Carp/Assert.pm

    # Take the square root of a number.
    sub my_sqrt {
        my($num) = shift;

        # the square root of a negative number is imaginary.
        assert($num >= 0);

        return sqrt $num;
    }

is( my_sqrt(4),  2,            'my_sqrt example with good input' );
ok( !eval{ my_sqrt(-1); 1 },   '  and pukes on bad' );

}

eval q{
  my $example = sub {
    local $^W = 0;

#line 291 lib/Carp/Assert.pm

    affirm {
        my $customer = Customer->new($customerid);
        my @cards = $customer->credit_cards;
        grep { $_->is_active } @cards;
    } "Our customer has an active credit card";

;

  }
};
is($@, '', "example from line 291");

