"""
A struct holding a question, its possible answers, and some metadata about its category and difficulty.
"""
struct Question
    question::String
    difficulty::Symbol
    correct_answer::String
    incorrect_answers::Vector{String}
    category::String
    qtype::Symbol
end

"""
Construct a `Question` from a dictionary of JSON data, as returned by the opentdb.com server.
"""
function Question(json::AbstractDict)
    Question(String(base64decode(json["question"])),
        Symbol(String(base64decode(json["difficulty"]))),
        String(base64decode(json["correct_answer"])),
        [String(base64decode(x)) for x in json["incorrect_answers"]],
        String(base64decode(json["category"])),
        Symbol(String(base64decode(json["type"]))))
end

"""
Request a list of categories from the opentdb.com server. Returns a dictionary mapping category IDs
to category names.
"""
function request_categories()
    url = "https://opentdb.com/api_category.php"
    r = check_http_response(
        HTTP.request("GET", url))
    data = JSON.parse(String(r.body))["trivia_categories"]
    Dict{Int, String}(entry["id"] => entry["name"] for entry in data)
end

"""
Request a list of questions from the server. 

* `amount [10]`: number of questions
* `answer_type [nothing]`: type of question, can be `:multiple` or `:boolean` (for True-False) or `nothing` (for any type)
* `category [nothing]`: question category, can be an integer or `nothing` (for any category). See `request_categories`
* `difficulty [nothing]`: desired difficulty, can be `:easy`, `:medium`, `:hard`, or `nothing` (for any difficulty)
"""
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
