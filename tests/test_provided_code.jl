using Base.Test
using Parser
using Types

##
## This module contains a few tests for the code provided for part 1.
## All tests here should already pass, and should be of no concern to
## you as a workshop attendee.
##

## Tests for find_matching_paren function in parser.py


function test_find_matching_paren()
    source = "(foo (bar) '(this ((is)) quoted))"
    @test 33 == find_matching_paren(source, 1)
    @test 10 == find_matching_paren(source, 6)
end

function test_find_matching_empty_parens()
    @test 2 == find_matching_paren("()", 1)
end

## If asked to find closing paren from an index where there is no opening
## paren, the function should raise an error
function test_find_matching_paren_throws_exception_on_bad_initial_position()
    @test_throws ErrorException find_matching_paren("string without parens", 5)
end

## The function should raise error when there is no matching paren to be found
function test_find_matching_paren_throws_exception_on_no_closing_paren()
    @test_throws LispError find_matching_paren("string (without closing paren", 8)
end



## Tests for unparse in parser.py


function test_unparse_atoms()
    @test "123" == unparse(123)
    @test "#t" == unparse(true)
    @test "#f" == unparse(false)
    @test "foo" == unparse("foo")
end

function test_unparse_list()
    @test "((foo bar) baz)" == unparse({{"foo", "bar"}, "baz"})
end

function test_unparse_quotes()
    @test "''(foo 'bar '(1 2))" == unparse(
        {"quote", {"quote", {"foo", {"quote", "bar"}, {"quote", {1, 2}}}}})
end

function test_unparse_bool()
    @test "#t" == unparse(true)
    @test "#f" == unparse(false)
end

function test_unparse_int()
    @test "1" == unparse(1)
    @test "1337" == unparse(1337)
    @test "-42" == unparse(-42)
end

function test_unparse_symbol()
    @test "+" == unparse("+")
    @test "foo" == unparse("foo")
    @test "lambda" == unparse("lambda")
end

function test_unparse_another_list()
    @test "(1 2 3)" == unparse([1, 2, 3])
    @test "(if #t 42 #f)" == unparse(["if", true, 42, false])
end

function test_unparse_other_quotes()
    @test "'foo" == unparse(["quote", "foo"])
    @test "'(1 2 3)" == unparse({"quote", [1, 2, 3]})
end

function test_unparse_empty_list()
    @test "()" == unparse([])
end


test_find_matching_paren()
test_find_matching_empty_parens()
test_find_matching_paren_throws_exception_on_bad_initial_position()
test_find_matching_paren_throws_exception_on_no_closing_paren()
test_unparse_atoms()
test_unparse_list()
test_unparse_quotes()
test_unparse_bool()
test_unparse_int()
test_unparse_symbol()
test_unparse_another_list()
test_unparse_other_quotes()
test_unparse_empty_list()
