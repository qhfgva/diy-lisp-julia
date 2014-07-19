## 
## We will start by implementing evaluation of simple expressions.
## 

using Base.Test
using Types
using Evaluator
using Parser

## Booleans should evaluate to themselves.
function test_evaluating_boolean()
    @test true ==  evaluate(true, Environment())
    @test false == evaluate(false, Environment())
end


## ...and so should integers.
function test_evaluating_integer()
    @test 42 == evaluate(42, Environment())
end


## When a call is done to the `quote` form, the argument should be returned without 
## being evaluated.

## (quote foo) -> foo
function test_evaluating_quote()
    @test "foo" == evaluate({"quote", "foo"}, Environment())
    @test {1, 2, false} == evaluate({"quote", {1, 2, false}}, Environment())
end


## The `atom` form is used to determine whether an expression is an atom.

## Atoms are expressions that are not list, i.e. integers, booleans or symbols.
## Remember that the argument to `atom` must be evaluated before the check is done.
function test_evaluating_atom_function()
    @test true == evaluate({"atom", true}, Environment())
    @test true == evaluate({"atom", false}, Environment())
    @test true == evaluate({"atom", 42}, Environment())
    @test true == evaluate({"atom", {"quote", "foo"}}, Environment())
    @test false == evaluate({"atom", {"quote", {1, 2}}}, Environment())
end



## The `eq` form is used to check whether two expressions are the same atom.
function test_evaluating_eq_function()
    @test true == evaluate({"eq", 1, 1}, Environment())
    @test false == evaluate({"eq", 1, 2}, Environment())

    # From this point, the ASTs might sometimes be too long or cummbersome to
    # write down explicitly, and we'll use `parse` to make them for us.
    # Remember, if you need to have a look at exactly what is passed to `evaluate`, 
    # just add a print statement in the test (or in `evaluate`).

    @test true == evaluate(parse("(eq 'foo 'foo)"), Environment())
    @test false == evaluate(parse("(eq 'foo 'bar)"), Environment())

    # Lists are never equal, because lists are not atoms
    @test false == evaluate(parse("(eq '(1 2 3) '(1 2 3))"), Environment())
end


## To be able to do anything useful, we need some basic math operators.

## Since we only operate with integers, `/` must represent integer division.
## `mod` is the modulo operator.
function test_basic_math_operators()
    @test 4 == evaluate({"+", 2, 2}, Environment())
    @test 1 == evaluate({"-", 2, 1}, Environment())
    @test 3 == evaluate({"/", 6, 2}, Environment())
    @test 3 == evaluate({"/", 7, 2}, Environment())
    @test 6 == evaluate({"*", 2, 3}, Environment())
    @test 1 == evaluate({"mod", 7, 2}, Environment())
    @test true == evaluate({">", 7, 2}, Environment())
    @test false == evaluate({">", 2, 7}, Environment())
    @test false == evaluate({">", 7, 7}, Environment())
end


## The math functions should only allow numbers as arguments.
function test_math_operators_only_work_on_numbers()
    ####@test_throws LispError parse("(foo (bar x y)))")
    @test_throws LispError evaluate(parse("(+ 1 'foo)"), Environment())
    @test_throws LispError evaluate(parse("(- 1 'foo)"), Environment())
    @test_throws LispError evaluate(parse("(/ 1 'foo)"), Environment())
    @test_throws LispError evaluate(parse("(mod 1 'foo)"), Environment())
end



test_evaluating_boolean()
test_evaluating_integer()
test_evaluating_quote()                          
test_evaluating_atom_function()
test_evaluating_eq_function()
test_basic_math_operators()
test_math_operators_only_work_on_numbers()
