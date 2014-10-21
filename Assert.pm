=head1 NAME 

Carp::Assert - stating the obvious to let the computer know

=head1 SYNOPSIS

    # Assertations are on.
    use Carp::Assert;
    assert(1 == 1) if DEBUG;
    
    # Assertations are off.
    use Carp::Assert qw(:NDEBUG);
    assert(1 == 1) if DEBUG;


=head1 DESCRIPTION

    "We are ready for any unforseen event that may or may not 
    occur."
        - Dan Quayle

Carp::Assert is intended for a purpose like the ANSI C library assert.h.
If you're already familiar with assert.h, then you can probably skip this and
go straight to the FUNCTIONS section.

Assertations are the explict expressions of your assumptions about the reality
your program is expected to deal with, and a declaration of those which it is
not.  They are used to prevent your program from blissfully processing garbage
inputs (garbage in, garbage out becomes garbage in, error out) and to tell you
when you've produced garbage output.  (If I was going to be a cynic about Perl
and the user nature, I'd say there are no user inputs but garbage, and Perl
produces nothing but...)

An assertation is used to prevent the impossible from being asked of your
code, or at least tell you when it does.  For example:
    
    # Take the square root of a number.
    sub my_sqrt {
        my($num) = shift;

        # the square root of a negative number is imaginary.
        assert($num >= 0);

        return sqrt $num;
    }

The assertation will warn you if a negative number was handed to your
subroutine, a reality the routine has no intention of dealing with.

An assertation should also be used a something of a reality check, to make
sure what your code just did really did happen:

    open(FILE, $filename) || die $!;
    @stuff = <FILE>;
    @stuff = do_something(@stuff);
    
    # I should have some stuff.
    assert(scalar(@stuff) > 0);
    
The assertation makes sure you have some @stuff at the end.  Maybe the file
was empty, maybe do_something() returned an empty list... either way, the
assert() will give you a clue as to where the problem lies, rather than 50
lines down when you print out @stuff and discover it to be empty.

Since assertations are designed for debugging and will remove themelves from
production code, your assertations should be carefully crafted so as to not
have any side-effects, change any variables or otherwise have any effect on
your program.  Here is an example of a bad assertation:

    assert($error = 1 if $king ne 'Henry');  # bad!

It sets an error flag which may then be used somewhere else in your program. 
When you shut off your assertations with the $DEBUG flag, $error will no
longer be set.


=head1 FUNCTIONS

=head2 assert

    assert(1==1) if DEBUG;

assert's functionality is effected by compile time value of the DEBUG constant.  If DEBUG is true, assert will function as below.  If
DEBUG is false the assert function will compile itself out of the program.  
See L<Debugging vs Production> for details.

Give assert an expression, assert will Carp::confess() if that expression is
false, return undef if it is true (DO NOT use the return value of assert for
anything, I mean it... really!).


=head1 Debugging vs Production

Because assertations are extra code and because it is sometimes necessary to
place them in 'hot' portions of your code where speed is paramount,
Carp::Assert provides the option to remove its assert() calls from your
program.

So, we provide a way to force Perl to inline the switched off assert()
routine, thereby removing almost all performance impact on your production
code.

    use Carp::Assert qw(:NDEBUG);  # assertations are off.
    assert(1==1) if DEBUG;

DEBUG is a constant set to 0.  Adding the 'if DEBUG' condition on your
assert() call gives perl the cue to go ahead and remove assert() call from
your program entirely, since the if conditional will always be false.

(This is the best I can do without requiring Filter::cpp)

You can safely leave out the "if DEBUG" part, but then your assert() function
will always execute.  Oh well.


=head1 Differences from ANSI C

assert() is intended to act like the function from ANSI C fame. 
Unfortunately, due to perl's lack of macros or strong inlining, it's not
nearly as unobtrusive.

Well, the obvious one is the "if DEBUG" part.  This is cleanest way I could
think of to cause each assert() call and its arguments to be removed from
the program at compile-time, like the ANSI C macro does.

Also, this version of assert does not report the statement which failed,
just the line number and call frame via Carp::confess.  This was an
interface issue, since "assert('1 == 1') if DEBUG;  looked really ugly.
And with Perl, unlike C, you always have the source to look through, so the
need isn't as great.


=head1 BUGS, CAVETS and other MUSINGS

Someday, Perl will have an inline pragma, and the "if DEBUG" bletcherousness
will go away.


=head1 AUTHOR

Michael G Schwern <schwern@pobox.com>

=cut

package Carp::Assert;

require 5;

use strict;
use Exporter;

use vars qw(@ISA @EXPORT @EXPORT_OK $VERSION %EXPORT_TAGS);

BEGIN {
    $VERSION = 0.06;
    
    @ISA = qw(Exporter);

    @EXPORT = qw(assert DEBUG);
    %EXPORT_TAGS = (
					NDEBUG => [qw(assert DEBUG)],
					DEBUG  => [qw(assert DEBUG)],
               	   );
    Exporter::export_tags(qw(NDEBUG DEBUG));
}

use subs qw(DEBUG);
use constant REAL_DEBUG => 1;
use constant NDEBUG 	=> 0;

# Export the proper DEBUG flag according to if :NDEBUG is set.
sub import {
	if( grep /^:NDEBUG/, @_ ) { 
		*DEBUG = *NDEBUG;
	}
	else {
		*DEBUG = *REAL_DEBUG;
	}
	Carp::Assert->export_to_level(1, @_);
}

require Carp;
sub assert ($) { 
	$_[0] or
    &Carp::confess("Assert failed");
    return undef; 
}


return q|You don't just EAT the largest turnip in the world!|;
