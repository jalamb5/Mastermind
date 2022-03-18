class Pegs
    attr_accessor :PEG, :peg_choice
    PEG = ['red', 'blue', 'yellow', 'green', 'purple', 'orange']
    def initialize(peg_choice)
        @peg_choice = peg_choice
    end

    def select_peg
        PEG[peg_choice]
    end
end

class CodeGenerator
    def generate_code
        code = []
        while code.length < 4
            computer_choice = rand(6)
            code << Pegs.new(computer_choice).select_peg          
        end
        code
    end
end

class GuessAnalyzer
    attr_accessor :guess, :secret_code
    def initialize(guess, secret_code)
        @guess = guess
        @secret_code = secret_code
    end

    def retrievePegs(guess)
        guess_code = []
        guess.each do |num|
            guess_code << Pegs.new(num.to_i).select_peg
        end
        guess_code
    end

    def compare_guesses
        guess_code = retrievePegs(guess)
        if guess_code == secret_code
            return true
        else
            return false
        end
    end

end

class Game
    def initialize
        secret_code = CodeGenerator.new.generate_code
        p secret_code
        correct_guess = false
        puts "Welcome to Mastermind. The computer has created a secret code."
        puts "Enter your guess as a 4 digit number. 0-Red, 1-Blue, 2-Yellow, 3-Green, 4-Purple, 5-Orange"
        while correct_guess == false
            puts "Incorrect. Guess again"
            guess = gets.strip.split('')
            correct_guess = GuessAnalyzer.new(guess, secret_code).compare_guesses
        end
        puts "You win!"
    end
end

Game.new