-module(a).

-spec main(X, Y) -> any() when
      X :: b:my_int0() | b:my_int1(),
      Y :: b:my_float0() | b:my_float1().
main(X, Y) ->
    b:add0(X, Y),
    b:add1(X, Y),
    subtract0(X, Y),
    main(),
    subtract1(X, Y).

subtract0(X, Y) ->
    X / Y.

subtract1  (X, Y) ->
    X / Y.
