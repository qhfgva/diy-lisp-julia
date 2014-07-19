
using Types
using Interpreter
using Base.Test

## Tests Greates Common Dividor (GCD).
function test_gcd()
    program = "
        (define gcd
            (lambda (a b)
                (if (eq b 0)
                    a 
                    (gcd b (mod a b)))))
    "

    env = Environment()
    interpret(program, env)

    @test "6" == interpret("(gcd 108 30)", env)
    @test "1" == interpret("(gcd 17 5)", env)
end


test_gcd()
