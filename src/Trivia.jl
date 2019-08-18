module Trivia

using HTTP
using JSON
using Base64
using Random

export Token, request_questions, present, prompt

include("core.jl")
include("interactive.jl")

end # module
