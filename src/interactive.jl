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
