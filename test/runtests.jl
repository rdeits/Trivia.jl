using Test
using Trivia

@testset "Trivia" begin
    @testset "tokens" begin
        t1 = Trivia.get_or_request_token()
        t2 = Trivia.get_or_request_token()
        @test t1.value == t2.value
        t4 = Trivia.Token()
        @test t4.value == t1.value

        t3 = Trivia.request_token()
        @test t1.value != t3.value

        Trivia.reset!(t3)
    end

    @testset "categories" begin
        categories = Trivia.request_categories()
        @test (9 => "General Knowledge") in categories
    end

    @testset "questions" begin
        token = Trivia.request_token()
        questions = Trivia.request_questions(token, amount=12)
        @test length(questions) == 12
        for question in questions
            present(question)
        end
    end
end
