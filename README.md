The Mars robot interface.

Main code in directory src, tests in spec.  All the rest (mostly
auto-generated) is part of a tiny Rails application that demonstrates the
interface.  It is available at http://mars-rover.herokuapp.com

Written in fairly standard Ruby (tested with 2.0.0 and 2.1.1); it should be
enough to run `bundle` in the top-level directory, then `rspec` to run the
tests.

Standalone executable in bin/run; can read the instruction either from file(s)
specified as argument(s) to the script, or from the standard input; but beware
of carriage returns when typing on the standard input (see commment in the
file).

TODO: full coverage, validations, more robust user interface

Copyright (c) Arthur Reutenauer, 30 April - 5 May 2014.<br />
This code is placed under the terms of the [MIT licence](http://opensource.org/licenses/MIT).<br />
BachoTeX & Warsaw, Poland.
