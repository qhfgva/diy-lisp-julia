
using Base.Test
using Types
using Evaluator
using Parser

## Before we go on to evaluating programs using variables, we need to implement
## an envionment to store them in.

## It is time to fill in the blanks in the `Environment` class located in `types.py`.


## An environment should store variables and provide lookup.
function test_simple_lookup()
    env = Environment()
    env = Environment({"var" => 42})
    @test 42 == lookup(env, "var")
end


## When looking up an undefined symbol, an error should be raised.

## The error message should contain the relevant symbol, and inform that it has 
## not been defined.
function test_lookup_on_missing_raises_exception()
    @test_throws LispError let empty_env = Environment()
                               lookup(empty_env, "my-missing-var")
                           end
end


## The `extend` function returns a new environment extended with more bindings.
function test_lookup_from_inner_env()
    env = Environment({"foo" => 42})
    env = extend(env, {"bar" => true})
    @test 42 == lookup(env, "foo")
    @test true == lookup(env, "bar")
end


## Extending overwrites old bindings to the same variable name.
function test_lookup_deeply_nested_var()
    env = Environment({"a" => 1})
    env = extend(env, {"b" => 2})
    env = extend(env, {"c" => 3})
    env = extend(env, {"foo" => 100})
    @test 100 == lookup(env, "foo")
end


## The extend method should create a new environment, leaving the old one unchanged.
function test_extend_returns_new_environment()
    env = Environment({"foo" => 1})
    extended = extend(env, {"foo" => 2})

    @test 1 == lookup(env, "foo")
    @test 2 == lookup(extended, "foo")
end
                          

## When calling `set` the environment should be updated
function test_set_changes_environment_in_place()
    env = Environment()
    set(env,"foo", 2)
    @test 2 == lookup(env, "foo")
end


## Variables can only be defined once.

## Setting a variable in an environment where it is already defined should result
## in an appropriate error.
function test_redefine_variables_illegal()
    env = Environment({"foo" => 1})
    @test_throws LispError set(env, "foo", 2)
end


# """
# With the `Environment` working, it's time to implement evaluation of expressions 
# with variables.
# """


## Symbols (other than #t and #f) are treated as variable references.

## When evaluating a symbol, the corresponding value should be looked up in the 
## environment.
function test_evaluating_symbol()
    env = Environment({"foo" => 42})
    @test 42 == evaluate("foo", env)
end

## Referencing undefined variables should raise an appropriate exception.

## This test should already be working if you implemented the environment correctly.
function test_lookup_missing_variable()
    @test_throws LispError evaluate("my-var", Environment())
end


## Test of simple define statement.

## The `define` form is used to define new bindings in the environment.
## A `define` call should result in a change in the environment. What you
## return from evaluating the definition is not important (although it 
## affects what is printed in the REPL).
function test_define()
    env = Environment()
    evaluate(parse("(define x 1000)"), env)
    @test 1000 == lookup(env, "x")
end

## Defines should have exactly two arguments, or raise an error
function test_define_with_wrong_number_of_arguments()
    @test_throws LispError evaluate(parse("(define x)"), Environment())
    @test_throws LispError evaluate(parse("(define x 1 2)"), Environment())
end

## Defines require the first argument to be a symbol.
function test_define_with_nonsymbol_as_variable()
    @test_throws LispError evaluate(parse("(define #t 42)"), Environment())
end

## Test define and lookup variable in same environment.

## This test should already be working when the above ones are passing.
function test_variable_lookup_after_define()
    env = Environment()
    evaluate(parse("(define foo (+ 2 2))"), env)
    @test 4 == evaluate("foo", env)
end




test_simple_lookup()
test_lookup_on_missing_raises_exception()
test_lookup_from_inner_env()
test_lookup_deeply_nested_var()
test_extend_returns_new_environment()
test_set_changes_environment_in_place()
test_redefine_variables_illegal()
test_evaluating_symbol()
test_lookup_missing_variable()
test_define()
test_define_with_wrong_number_of_arguments()
test_define_with_nonsymbol_as_variable()
test_variable_lookup_after_define()
