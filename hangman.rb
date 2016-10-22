require 'YAML'
require 'CSV'

#should be inner class of game?
class Player
	attr_accessor :wins, :losses, :turn, :correct_letters, :word_to_guess
	attr_reader :name
	def initialize(name)
		@name = name
		@wins = 0
		@losses = 0
		@turn = 0
		@word_to_guess = ""
		@correct_letters = []
	end
end

class Game
	def initialize()
		@player = Player.new("Marcus")
		puts "New game, or load previous save?"
		input = gets.chomp
		if input == "new game"
			setup
		elsif input == "load game"
			output = File.new('save.yml', 'r')
  			@player = YAML::load(output.read)
			game_loop
		end
	end

	def setup
		words = []
			file = File.open("5desk.txt", "r")
			while !file.eof?
				line = file.readline
				length = line.length - 2
				if length.between?(5,12)
					words << line
				end
			end

			word = words.sample.chomp
			@player.word_to_guess = word.split("")
			p @player.word_to_guess

			game_loop
	end

	#get player input
	#append to correct_letters if correct.
	def input
		print_word
		print "\n>> "
		input = gets.chomp
		if @player.word_to_guess.include? input
			@player.correct_letters << input
		elsif input == "save game"
			output = File.new('save.yml', 'w')
			output.puts YAML.dump(@player)
			output.close
			puts ">game saved<"
			game_loop
		elsif input == "exit"
			exit
		else
			@player.turn += 1
		end
	end

	#print out up-to-date words.
	def print_word
		$current_print = []
		@player.word_to_guess.each_with_index do |i,index|
			if @player.correct_letters.include? i
				$current_print << "#{i}"
			else
				$current_print << " _"
			end
		end
		print $current_print.join
	end

	def check_win
		if @player.word_to_guess.join("") == $current_print.join("")
			@player.wins += 1
			print "win!\n"
			play_again?
		end
	end

	def play_again?
		print "Play again?: "
		input = gets.chomp
		if input == "yes"
			@player.turn = 0
			@player.correct_letters = []
			setup
			game_loop
		else
			exit
		end
	end

	def game_loop
		while @player.turn != 10 do
			puts "Turn #{@player.turn} / 10"
			input
			check_win
			if @player.turn == 10
				puts "Out of turns, you lose."
				play_again?
			end
		end
	end
end

game = Game.new






















