
using Base.Test
using Evaluator
using Types
using Parser

## Remember, functions should evaluate their arguments. 

## (Except `quote` and `if`, that is, which aren't really functions...) Thus, 
## nested expressions should work just fine without any further work at this 
## point.

## If this test is failing, make sure that `+`, `>` and so on is evaluating 
## their arguments before operating on them."""
function test_nested_expression()
    nested_expression = parse("(eq #f (> (- (+ 1 3) (* 2 (mod 7 4))) 4))")
    @test true == evaluate(nested_expression, Environment())
end


## If statements are the basic control structures.

## The `if` should first evaluate it's first argument. If this evaluates to true, then
## the second argument is evaluated and returned. Otherwise the third and last argument
## is evaluated and returned instead.
function test_basic_if_statement()
    if_expression = parse("(if #t 42 1000)")
    @test 42 == evaluate(if_expression, Environment())
end


## The branch of the if statement that is discarded should never be evaluated.
function test_that_only_correct_branch_is_evaluated()
    if_expression = parse("(if #f (this should not be evaluated) 42)")
    @test 42 == evaluate(if_expression, Environment())
end

                          

## A final test with a more complex if expression.
## This test should already be passing if the above ones are.
function test_if_with_sub_expressions()
    if_expression = parse("
        (if (> 1 2)
            (- 1000 1)
            (+ 40 (- 3 1)))
    ")
    @test 42 == evaluate(if_expression, Environment())
end



test_nested_expression()
test_basic_if_statement()
test_that_only_correct_branch_is_evaluated()
test_if_with_sub_expressions()
