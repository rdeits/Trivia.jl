module Trivia

import HTTP
import JSON
using Base64: base64decode
using Random: shuffle!

export Token, request_questions, present, prompt, play_round

# This is the main source file for the Trivia.jl package. It defines the `Trivia` Julia module, 
# imports a few dependencies (HTTP, JSON, Base64, and Random), and lists a few helpful types
# and methods that will be exported.

# All of the actual work is split out into the following files:
include("requests.jl")
include("tokens.jl")
include("questions.jl")
include("interactive.jl")

end # module
