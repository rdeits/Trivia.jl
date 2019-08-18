default_token_file() = joinpath(@__DIR__, "..", "data", "token.txt")

function check_response(json)
    json["response_code"] == 0 || error("API returned non-zero response code: $(json["response_code"])")
    json
end

function check_http_response(r)
    r.status == 200 || error("Got HTTP status $(r.status)")
    r
end

function opentdb_request(url)
    r = check_http_response(
        HTTP.request("GET", url))
    json = check_response(JSON.parse(String(r.body)))
    json
end

struct Token
    value::String
end

struct Question
    question::String
    difficulty::Symbol
    correct_answer::String
    incorrect_answers::Vector{String}
    category::String
    qtype::Symbol
end

function Question(json::AbstractDict)
    Question(String(base64decode(json["question"])),
        Symbol(String(base64decode(json["difficulty"]))),
        String(base64decode(json["correct_answer"])),
        [String(base64decode(x)) for x in json["incorrect_answers"]],
        String(base64decode(json["category"])),
        Symbol(String(base64decode(json["type"]))))
end

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

Token() = get_or_request_token()

function reset!(t::Token)
    opentdb_request("https://opentdb.com/api_token.php?command=reset&token=" * t.value)
end

function request_categories()
    url = "https://opentdb.com/api_category.php"
    r = check_http_response(
        HTTP.request("GET", url))
    data = JSON.parse(String(r.body))["trivia_categories"]
    Dict(entry["id"] => entry["name"] for entry in data)
end

function request_questions(t::Token; amount::Union{Integer, Nothing}=10,
        answer_type::Union{Symbol, Nothing}=:multiple,
        category::Union{Integer, Nothing}=nothing,
        difficulty::Union{Symbol, Nothing}=nothing)
    url = "https://opentdb.com/api.php?token=$(t.value)&encode=base64"
    params = Pair{String, String}[]
    if amount !== nothing
        push!(params, "amount" => string(amount))
    end
    if category !== nothing
        push!(params, "category" => string(category))
    end
    if difficulty !== nothing
        push!(params, "difficulty" => string(difficulty))
    end
    if answer_type !== nothing
        push!(params, "type" => string(answer_type))
    end
    if !isempty(params)
        url *= "&" * join([join(p, "=") for p in params], "&")
    end
    json = opentdb_request(url)
    [Question(q) for q in json["results"]]
end

