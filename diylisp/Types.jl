
module Types

export Environment, Closure, LispError, lookup, extend, set

type LispError <: Exception
    msg::String
end

type Environment
    variables :: Dict{Any,Any}

    Environment() = new(Dict())
    function Environment(d::Dict{Any, Any})
        x = new()
        x.variables = d
        x
    end
end

function lookup(e::Environment, symbol::ASCIIString)
    throw(ErrorException("Not Implemented"))
end
    
function extend(e, variables)
    throw(ErrorException("Not Implemented"))
end

function set(e, symbol, value)
    throw(ErrorException("Not Implemented"))
end


type Closure
    ### This needs to be implemented by you !!!
end

end # module
