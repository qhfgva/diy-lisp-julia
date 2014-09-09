
module Interpreter

#using BallOfMud
using Parser
using Evaluator
using Types

export interpret, interpret_file

## Interpret a lisp program statement

## Accepts a program statement as a string, interprets it, and then
## returns the resulting lisp expression as string.
function interpret(source, env=Environment())
    unparse(evaluate(parse(source), env))
end

## Interpret a lisp file

## Accepts the name of a lisp file containing a series of statements. 
## Returns the value of the last expression of the file.
function interpret_file(filename, env=Environment())
    source = join(readlines(open(filename)), "\n")

    asts = parse_multiple(source)
    results = [evaluate(ast, env) for ast in asts]
    return unparse(results[end])
end

end # module
