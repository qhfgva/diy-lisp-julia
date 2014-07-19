using Base.Test
using Parser
using Evaluator
using Types

## One way to create lists is by quoting.

## We have already implemented `quote` so this test should already be
## passing.

## The reason we need to use `quote` here is that otherwise the expression would
## be seen as a call to the first element -- `1` in this case, which obviously isn't
## even a function.
function test_creating_lists_by_quoting()
    @test parse("(1 2 3 #t)") == evaluate(parse("'(1 2 3 #t)"), Environment())
end

## The `cons` functions prepends an element to the front of a list.
function test_creating_list_with_cons()
    result = evaluate(parse("(cons 0 '(1 2 3))"), Environment())
    @test parse("(0 1 2 3)") == result
end

## `cons` needs to evaluate it's arguments.

## Like all the other special forms and functions in our language, `cons` is 
## call-by-value. This means that the arguments must be evaluated before we 
## create the list with their values.
function test_creating_longer_lists_with_only_cons()
    result = evaluate(parse("(cons 3 (cons (- 4 2) (cons 1 '())))"), Environment())
    @test parse("(3 2 1)") ==  result
end

## `head` extracts the first element of a list.
function test_getting_first_element_from_list()
    @test 1 == evaluate(parse("(head '(1 2 3 4 5))"), Environment())
end

## If the list is empty there is no first element, and `head should raise an error.
function test_getting_first_element_from_empty_list()
    @test_throws LispError evaluate(parse("(head (quote ()))"), Environment())
end

## `tail` returns the tail of the list.

## The tail is the list retained after removing the first element.
function test_getting_tail_of_list()
    @test {2, 3} == evaluate(parse("(tail '(1 2 3))"), Environment())
end

## The `empty` form checks whether or not a list is empty.
function test_checking_whether_list_is_empty()
    @test false == evaluate(parse("(empty '(1 2 3))"), Environment())
    @test false == evaluate(parse("(empty '(1))"), Environment())

    @test true == evaluate(parse("(empty '())"), Environment())
    @test true == evaluate(parse("(empty (tail '(1)))"), Environment())
end

                          
test_creating_lists_by_quoting()
test_creating_list_with_cons()
test_creating_longer_lists_with_only_cons()
test_getting_first_element_from_list()
test_getting_first_element_from_empty_list()
test_getting_tail_of_list()
test_checking_whether_list_is_empty()
