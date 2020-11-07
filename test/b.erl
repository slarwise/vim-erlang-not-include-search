-module(b).

-type my_int0() :: integer().
-  type     my_int1() :: integer().
-opaque my_float0() :: float().
-   opaque      my_float1() :: float().

-export_type([my_int/0, my_float/0]).
-export([add/2]).

add0(X, Y) ->
    X + Y.

add1     (X, Y) ->
    X + Y.
