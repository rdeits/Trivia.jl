
default_token_file() = joinpath(@__DIR__, "..", "data", "token.txt")

struct Token
    value::String
end

Token() = get_or_request_token()

function request_token()
    json = opentdb_request("https://opentdb.com/api_token.php?command=request")
    Token(json["token"])
end

function save(filename::AbstractString, token::Token)
    open(filename, write=true) do file
        write(file, token.value)
    end
end

function get_or_request_token(filename=default_token_file())
    if isfile(filename)
        token = Token(open(r -> strip(read(r, String)), filename))
    else
        token = request_token()
        mkpath(dirname(filename))
        save(filename, token)
    end
    token
end

function reset!(t::Token)
    opentdb_request("https://opentdb.com/api_token.php?command=reset&token=" * t.value)
end
