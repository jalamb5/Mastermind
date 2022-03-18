class Pegs # Allow computer/user to select colored pegs
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

    def generate_pegs(secret_code) # convert number values to color peg values
        code = []
        secret_code.each do |num|
            code << Pegs.new(num.to_i).select_peg
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

    def give_feedback
        guess_code = retrievePegs(guess)
        right_color = 0
        right_position = 0

        guess_code.each_with_index do |guess, index|
            if secret_code[index] == guess
                right_position += 1
            elsif secret_code.include?(guess)
                right_color += 1
            end
        end
        return right_color, right_position, guess_code
    end
end

class ComputerCodeBreaker
    def computerGuess(right_color, right_position, guess_code)
        feedback_hash = {red: 1, blue: 1, yellow: 1, green: 1, purple: 1, orange: 1}
        translation_hash = {red: 0, blue: 1, yellow: 2, green: 3, purple: 4, orange: 5}
        unless guess_code.empty?
            if right_color.to_i > 0
                guess_code.each do |guess|
                    feedback_hash[guess.to_sym] += 50
                end
            elsif right_position.to_i > 0
                guess_code.each do |guess|
                    feedback_hash[guess.to_sym] += 100
                end
            else  
                guess_code.each do |guess|
                    feedback_hash[guess.to_sym] = 1
                end
            end
        end
# because I initially chose to use numbers to index into the pegs array, the color string values must be translated to ints to work in other methods.
        untranslated_guess = []
        feedback_hash.map do |color, weight|
            weight.times { untranslated_guess << color }
        end

        translated_guess = []
        untranslated_guess.map do |color|
            translated_guess << translation_hash[color]
        end

        guess = ['', '', '', '']
        guess.each_with_index do |num, index|
            guess[index] = translated_guess.sample
        end
        return guess
    end
end

class Game
    def initialize
        puts "Welcome to Mastermind."
        puts "Who will be the Codemaker? 1-Computer or 2-Player"
        codemaker = gets.strip.to_i
        if codemaker == 1
            gameLoop(1)
        elsif codemaker == 2
            gameLoop(2)
        else
            puts "You must enter 1 or 2\n"
            Game.new()
        end
    end

    def gameLoop(code_maker)
        code_maker == 1 ? player = 'You' : player = 'Computer'
        if code_maker == 1 # computer is codemaker
            secret_code = CodeGenerator.new.generate_code
            puts "The computer has created a secret code."
            puts "Enter your guess as a 4 digit number. 0-Red, 1-Blue, 2-Yellow, 3-Green, 4-Purple, 5-Orange"
        else # human is codemaker
            puts "Create your secret code."
            puts "Enter your code as a 4 digit number. 0-Red, 1-Blue, 2-Yellow, 3-Green, 4-Purple, 5-Orange"
            secret_code = CodeGenerator.new.generate_pegs(inputValidation())
        end
        correct_guess = false
        num_of_guess = 12 # number of rounds, game ends at 0
        right_color, right_position, guess_code = 0, 0, []
        while correct_guess == false
            if num_of_guess == 0
                break
            end
            code_maker == 1 ? guess = inputValidation() : guess = ComputerCodeBreaker.new.computerGuess(right_color, right_position, guess_code) # use feedback to inform computer guesses
            num_of_guess -= 1
            correct_guess = GuessAnalyzer.new(guess, secret_code).compare_guesses
            if correct_guess == false
                right_color, right_position, guess_code = GuessAnalyzer.new(guess, secret_code).give_feedback
                puts "#{right_color} - Right Colors and #{right_position} - Right Positions. Guess again. #{num_of_guess} guesses remaining."
            end
        end
        if correct_guess == true
            puts "#{player} guessed correctly in #{12 - num_of_guess} guesses"
        else puts "#{player} ran out of guesses!"
        end
    end

    def inputValidation # ensures all inputs are 4 digits and returns as array
        guess = gets.strip
        unless guess.length == 4 && guess.count("^0-9").zero?
            puts "Invalid selection. Choose again"
            inputValidation()
        end
        return guess.split('')
    end
end

Game.new