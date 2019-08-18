# This file includes functions for managing opentdb.com tokens. A token is a unique string
# which the server uses to identify an individual user. The opentdb.com API will use your
# unique token to ensure that you don't get a trivia question you've already seen.
#
# By default, this package will request a token for you and store it in `data/token.txt`.
# Any time you call `Token()` again, that saved token will be reused. You can get a brand
# new token with `request_token()` or you can simply delete the `data/token.txt` file if
# you want to completely start over.

default_token_file() = joinpath(@__DIR__, "..", "data", "token.txt")

"""
Basic struct wrapping a single string holding an opentdb.com API token
"""
struct Token
    value::String
end

"""
Construct a Token. By default, this will use an existing saved token in 
`data/token.txt`. If no token exists, one will be requested and saved.
"""
Token() = get_or_request_token()

"""
Request a brand new token.
"""
function request_token()
    json = opentdb_request("https://opentdb.com/api_token.php?command=request")
    Token(json["token"])
end

"""
Save the given token using the givne file name. 
"""
function save(filename::AbstractString, token::Token)
    open(filename, write=true) do file
        write(file, token.value)
    end
end

"""
Construct a Token. By default, this will use an existing saved token in 
`filename`. If no token exists, one will be requested and saved.
"""
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

"""
Tell the opentdb.com API to reset the given token. This deletes the history of that token
on the server, so when using this token again you may see questions that you have already
seen. 
"""
function reset!(t::Token)
    opentdb_request("https://opentdb.com/api_token.php?command=reset&token=" * t.value)
end
