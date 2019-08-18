using Revise
using Pkg
Pkg.activate(@__DIR__)

using Trivia

function play_round(token=Token())
    num_questions = tryparse(Int, prompt("How many questions? [6]: "))
    if num_questions === nothing
        num_questions = 6
    end
    categories = Trivia.request_categories()
    println("\nCategories:")
    for (id, name) in sort(categories)
        println(id, ": ", name)
    end
    category = tryparse(Int, prompt("Category ID? [leave empty for grab bag]: "))
    questions = request_questions(token, category=category, amount=num_questions)

    prompt("Press <enter> to start the round!")
    for (i, question) in enumerate(questions)
        println("Question $i:")
        present(question, true)
        if i < lastindex(questions)
            choice = prompt("Press <enter> to continue or `q` to quit: ")
            if lowercase(choice) == "q"
                break
            end
        end
    end
end

