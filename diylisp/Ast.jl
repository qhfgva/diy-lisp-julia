module Ast

using Types

export is_symbol, is_list, is_boolean, is_integer, is_closure, is_atom

function is_symbol(x)
    typeof(x) == ASCIIString
end

function is_list(x)
    issubtype(typeof(x), Array)
end

function is_boolean(x)
    typeof(x) == Bool
end

function is_integer(x)
    typeof(x) == Int32
end

function is_closure(x)
    typeof (x) == Closure
end

function is_atom(x)
    is_symbol(x) | is_integer(x) | is_boolean(x) | is_closure(x)
end

end # module
