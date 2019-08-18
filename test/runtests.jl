using Test
using Trivia

@testset "Trivia" begin
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
