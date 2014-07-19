module Repl

using Types
using Interpreter
using Parser 

export repl

## Start the interactive Read-Eval-Print-Loop
function repl()
    println()
    println("                 " * faded("                             \\`.    T       "))
    println("    Welcome to   " * faded("   .--------------.___________) \\   |    T  "))
    println("   the DIY-lisp  " * faded("   |//////////////|___________[ ]   !  T |  "))
    println("       REPL      " * faded("   `--------------'           ) (      | !  "))
    println("                 " * faded("                              '-'      !    "))
    println(faded("  use ^D to exit"))
    println()

    env = Environment()
    interpret_file(string(dirname(@__FILE__()), "/../", "stdlib.diy"), env)
    while true
        try
            source = read_expression()
            println(interpret(source, env))
        catch e
            if isa(e, LispError)
                println(colored("!", "red"))
                println(faded(string(typeof(e)) * ":"))
                println(string(e))
            elseif isa(e, InterruptException)
                msg = "Interupted. " * faded("(Use ^D to exit)")
                println("\n" * colored("! ", "red") * msg)
            elseif isa(e, EOFError)
                println(faded("\nBye! o/"))
                exit(0)
            elseif isa(e, Exception)
                println(colored("! ", "red") * faded("The Julia is showing through..."))
                println(faded("  " * string(e) * ":"))
                println(e)
                throw(e)
            end
        end
    end
end

## Read from stdin until we have at least one s-expression
function read_expression()
    exp = ""
    open_parens = 0
    while true
        line, parens = read_line(!isempty(strip(exp)) ? "->  " : "...  ")
        open_parens += parens
        exp *= line
        if !isempty(strip(exp)) && open_parens <= 0
            break
        end
    end
    return strip(exp)
end

function input(prompt::String="")
    print(prompt)
    chomp(readline())
end
                          
## Return touple of user input line and number of unclosed parens
function read_line(prompt)
    line = input(colored(prompt, "grey", "bold"))
    line = remove_comments(line * "\n")
    return line, count(x -> x == '(', line) - count(x -> x == ')', line)
end

function colored(text, color, attr=nothing)
    attributes = {
        "bold" => 1,
        "dark" => 2
    }
    colors = {
        "grey" => 30,
        "red" => 31,
        "green" => 32,
        "yellow" => 33,
        "blue" => 34,
        "magenta" => 35,
        "cyan" => 36,
        "white" => 37,
        "reset" => 0
    }

    if "ANSI_COLORS_DISABLED" in keys(ENV)
        return text
    end

    color = @sprintf "\033[%dm" colors[color]
    attr  = (attr != nothing) ? (@sprintf "\033[%dm" attributes[attr]) : ""
    reset = @sprintf "\033[%dm" colors["reset"]

    return color * attr * text * reset
end

function faded(text)
    colored(text, "grey", "bold")
end

end # module
