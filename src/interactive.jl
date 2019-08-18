function prompt(text::AbstractString)
    print(text)
    readline()
end

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
