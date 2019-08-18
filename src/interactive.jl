# This file includes functions for interactively loading and presenting a round of trivia
# questions

"""
Display the given text and then wait for the user to type something and press <enter>

Returns the text entered by the user.
"""
function prompt(text::AbstractString)
    print(text)
    readline()
end

"""
Present a single question, including its possible answers and its correct answer.

If `interactive=true`, then this function will pause before displaying the possible
answers and before displaying the correct answer.
"""
function present(q::Question, interactive=false)
    answers = vcat(q.incorrect_answers, q.correct_answer)
    shuffle!(answers)
    println(q.question)
    if interactive
        readline()
    end
    for (i, ans) in enumerate(answers)
        println('\t', 'A' - 1 + i, ": ", ans)
    end
    if interactive
        readline()
    end
    println("Answer: $(q.correct_answer)")
end

"""
Create and play an entire round of trivia questions. This function will prompt
the user for the desired number and category of questions and then present each
question individually.
"""
function play_round(token=Token())
    num_questions = tryparse(Int, prompt("How many questions? [6]: "))
    if num_questions === nothing
        num_questions = 6
    end
    println("Loading categories from opentdb.com...")
    categories = Trivia.request_categories()
    println("\nCategories:")
    for (id, name) in sort(categories)
        println(id, ": ", name)
    end
    category = tryparse(Int, prompt("Category ID? [leave empty for grab bag]: "))
    println("Requesting questions from opentdb.com...")
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
