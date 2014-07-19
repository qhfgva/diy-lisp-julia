
## from nose.tools import assert_equals, assert_raises_regexp

## from diylisp.parser import parse, unparse
## from diylisp.types import LispError

using Base.Test
using Types
using Parser

## Parsing a single symbol.

## Symbols are represented by text strings. Parsing a single atom should result
## in an AST consisting of only that symbol.
function test_parse_single_symbol()
    @test "foo" ==  parse("foo")
end

## Parsing single booleans.

## Booleans are the special symbols #t and #f. In the ASTs they are represented 
## by Pythons True and False, respectively.
function test_parse_boolean()
    @test true == parse("#t")
    @test false == parse("#f")
end

                          
## Parsing single integer.

## Integers are represented in the ASTs as Python ints.

## Tip: String objects have a handy .isdigit() method.
function test_parse_integer()
    @test 42 == parse("42")
    @test 1337 == parse("1337")
end

## Parsing list of only symbols.

## A list is represented by a number of elements surrounded by parens. Python lists 
## are used to represent lists as ASTs.

## Tip: The useful helper function `find_matching_paren` is already provided in
## `parse.py`.
function test_parse_list_of_symbols()
    @test ["foo", "bar", "baz"] == parse("(foo bar baz)")
    @test [] == parse("()")
end

## Parsing a list containing different types.

## When parsing lists, make sure each of the sub-expressions are also parsed 
## properly.
function test_parse_list_of_mixed_types()
    @test ["foo", true, 123] == parse("(foo #t 123)")
end


## Parsing should also handle nested lists properly.
function test_parse_on_nested_list()
    program = "(foo (bar ((#t)) x) (baz y))"
    ast = {"foo",
           {"bar", {{true}}, "x"},
           {"baz", "y"}}
    @test ast == parse(program)
end
                          
## The proper exception should be raised if the expresions is incomplete.
function test_parse_exception_missing_paren()
    @test_throws LispError parse("(foo (bar x y)")
end


## Another exception is raised if the expression is too large.

## The parse function expects to receive only one single expression. Anything
## more than this, should result in the proper exception.
function test_parse_exception_extra_paren()
    @test_throws LispError parse("(foo (bar x y)))")
end


## Excess whitespace should be removed.
function test_parse_with_extra_whitespace()
    program = "

       (program    with   much        whitespace)
    "
    expected_ast = {"program", "with", "much", "whitespace"}
    @test expected_ast == parse(program)
end


## All comments should be stripped away as part of the parsing.
function test_parse_comments()
    program = "
    ;; this first line is a comment
    (define variable
        ; here is another comment
        (if #t 
            42 ; inline comment!
            (something else)))
    "
    expected_ast = {"define", "variable",
                    {"if", true,
                     42,
                     {"something", "else"}}}
    @test expected_ast == parse(program)
end


## Test a larger example to check that everything works as expected
function test_parse_larger_example()
    program = "
        (define fact 
        ;; Factorial function
        (lambda (n) 
            (if (<= n 1) 
                1 ; Factorial of 0 is 1, and we deny 
                  ; the existence of negative numbers
                (* n (fact (- n 1))))))
    "
    ast = {"define", "fact",
           {"lambda", {"n"},
            {"if", {"<=", "n", 1},
             1,
             {"*", "n", {"fact", {"-", "n", 1}}}}}}
    @test ast == parse(program)
end


## The following tests checks that quote expansion works properly


                          
## Quoting is a shorthand syntax for calling the `quote` form.

## Examples:

##     'foo -> (quote foo)
##     '(foo bar) -> (quote (foo bar))
function test_expand_single_quoted_symbol()
    @test {"foo", {"quote", "nil"}} == parse("(foo 'nil)")
end


function test_nested_quotes()
    @test {"quote", {"quote", {"quote", {"quote", "foo"}}}} == parse("''''foo")
end


## One final test to see that quote expansion works.
function test_expand_crazy_quote_combo()
    source = "'(this ''''(makes ''no) 'sense)"
    @test source == unparse(parse(source))
end

                           
test_parse_single_symbol()
test_parse_boolean()
test_parse_integer()
test_parse_list_of_symbols()
test_parse_list_of_mixed_types()
test_parse_on_nested_list()
test_parse_exception_missing_paren()
test_parse_exception_extra_paren()
test_parse_with_extra_whitespace()
test_parse_comments()
test_parse_larger_example()
test_expand_single_quoted_symbol()
test_nested_quotes()
test_expand_crazy_quote_combo()

