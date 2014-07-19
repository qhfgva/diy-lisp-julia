using Base.Test
using Interpreter
using Types

env = Environment()
path = string(dirname(@__FILE__()), "/../", "stdlib.diy")
interpret_file(path, env)


## Consider these tests as suggestions for what a standard library for
## your language could contain. Each test function tests the implementation
## of one stdlib function.

## Put the implementation in the file `stdlib.diy` at the root directory
## of the repository. The first function, `not` is already defined for you.
## It's your job to create the rest, or perhaps somthing completely different?

## Anything you put in `stdlib.diy` is also available from the REPL, so feel
## free to test things out there.

##     $ ./repl 
##     →  (not #t)
##     #f

## PS: Note that in these tests, `interpret` is used. In addition to parsing 
## and evaluating, it "unparses" the result, hence strings such as "#t" as the 
## expected result instead of `True`.


function test_not()
    @test "#t" == interpret("(not #f)", env)
    @test "#f" == interpret("(not #t)", env)
end

function test_or()
    @test "#f" == interpret("(or #f #f)", env)
    @test "#t" == interpret("(or #t #f)", env)
    @test "#t" == interpret("(or #f #t)", env)
    @test "#t" == interpret("(or #t #t)", env)
end

function test_and()
    @test "#f" == interpret("(and #f #f)", env)
    @test "#f" == interpret("(and #t #f)", env)
    @test "#f" == interpret("(and #f #t)", env)
    @test "#t" == interpret("(and #t #t)", env)
end

function test_xor()
    @test "#f" == interpret("(xor #f #f)", env)
    @test "#t" == interpret("(xor #t #f)", env)
    @test "#t" == interpret("(xor #f #t)", env)
    @test "#f" == interpret("(xor #t #t)", env)
end

function test_greater_or_equal()
    @test "#f" == interpret("(>= 1 2)", env)
    @test "#t" == interpret("(>= 2 2)", env)
    @test "#t" == interpret("(>= 2 1)", env)
end

function test_less_or_equal()
    @test "#t" == interpret("(<= 1 2)", env)
    @test "#t" == interpret("(<= 2 2)", env)
    @test "#f" == interpret("(<= 2 1)", env)
end

function test_less_than()
    @test "#t" == interpret("(< 1 2)", env)
    @test "#f" == interpret("(< 2 2)", env)
    @test "#f" == interpret("(< 2 1)", env)
end

function test_sum()
    @test "5" == interpret("(sum '(1 1 1 1 1))", env)
    @test "10" == interpret("(sum '(1 2 3 4))", env)
    @test "0" == interpret("(sum '())", env)
end

function test_length()
    @test "5" == interpret("(length '(1 2 3 4 5))", env)
    @test "3" == interpret("(length '(#t '(1 2 3) 'foo-bar))", env)
    @test "0" == interpret("(length '())", env)
end

function test_append()
    @test "(1 2 3 4 5)" == interpret("(append '(1 2) '(3 4 5))", env)
    @test "(#t #f 'maybe)" == interpret("(append '(#t) '(#f 'maybe))", env)
    @test "()" == interpret("(append '() '())", env)
end

function test_filter()
    interpret("
        (define even
            (lambda (x)
                (eq (mod x 2) 0)))
    ", env)
    @test "(2 4 6)" == interpret("(filter even '(1 2 3 4 5 6))", env)
end

function test_map()
    interpret("
        (define inc
            (lambda (x) (+ 1 x)))
    ", env)
    @test "(2 3 4)" == interpret("(map inc '(1 2 3))", env)
end

function test_reverse()
    @test "(4 3 2 1)" == interpret("(reverse '(1 2 3 4))", env)
    @test "()" == interpret("(reverse '())", env)
end

function test_range()
    @test "(1 2 3 4 5)" == interpret("(range 1 5)", env)
    @test "(1)" == interpret("(range 1 1)", env)
    @test "()" == interpret("(range 2 1)", env)
end

function test_sort()
    @test "(1 2 3 4 5 6 7)" == interpret("(sort '(6 3 7 2 4 1 5))", env)
    @test "()" == interpret("'()", env)
end                          



test_not()
test_or()
test_and()
test_xor()
test_greater_or_equal()
test_less_or_equal()
test_less_than()
test_sum()
## test_length()
## test_append()
## test_filter()
## test_map()
## test_reverse()
## test_range()
## test_sort()

