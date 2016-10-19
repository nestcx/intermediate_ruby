class Block
	attr_accessor :block

	def initialize
		@block = ["-","-","-","-"]
	end

	def print_block
		puts "#{@block[3]} | #{@block[2]}"
		puts "#{@block[1]} | #{@block[0]}"
	end

	def reset_block
		@block = ["-","-","-","-"]
	end

	def add_to_block(info)
		i = 0
		while true
			if @block[i] == "-"
				@block[i] = info
				break
			else
				i += 1
			end
		end
	end
end

class Player
	attr_accessor :name, :wins, :value

	def initialize(name)
		@name = name
		@wins = 0
	end

	def input
		gets.chomp.split(",")
	end
end

class Computer < Player
	@@colours = ["red", "green", "blue", "yellow", "brown", "purple"]

	def colour_ai
		if $match.uniq != []
			@current_choice.map!.with_index do |color, index|
				if $match.uniq.include? index
					@current_choice[index] = @current_choice[index]
				else
					@current_choice[index] = @@colours.sample
				end
			end
		else
		@current_choice = []
		0.upto(3) do
			@current_choice.push(@@colours.sample)
		end
		end
	end

	def input
		colour_ai
		print "#{@current_choice}\n"
		@value = @current_choice
	end
end

class Game
	@@colours = ["red", "green", "blue", "yellow", "brown", "purple"]

	def initialize(user)
		@player = Player.new(user)
		@computer = Computer.new("Computer")
		@block = Block.new
		coder_or_guesser
	end

	private 

	def coder_or_guesser
		puts "Will you be the 'coder', or 'guesser': "
		input = gets.chomp
		if input == "coder"
			@coder = @player
			@guesser = @computer
			do_colours("coder")
		elsif input == "guesser"
			@coder = @computer
			@guesser = @player
			do_colours("guesser")
		end
		start
	end

	def start
		@block.reset_block
		game_loop
	end

	def do_colours(person)
		@coder_colours = []
		if person == "guesser"
			0.upto(3) do
				@coder_colours << @@colours.sample
			end
		else
			puts "Enter secret colour code: "
			input = gets.chomp.split(",")
			input.each do |x|
				@coder_colours << x
			end
		end
	end

	def check_win
		u = @block.block.all? do |x|
			x == "C"
		end
		if u == true
			puts "-------------------------------"
			puts "#{@guesser.name} wins!\n"
			@guesser.wins += 1
			puts "-------------------------------"
			puts "#{@guesser.name} wins: #{@guesser.wins}"
			puts "#{@coder.name} wins: #{@coder.wins}\n"
			puts "-------------------------------"
			play_again?
		end
	end

	def play_again?
		print "play again? (yes/no): "
		input = gets.chomp.downcase
		if input == "yes"
			coder_or_guesser
		else
			exit
		end
	end

	def game_loop
		$match = []
		#p @coder_colours
		for i in 1..12
			puts "Turn no: #{i}/12"
			print ">> "
			x = @guesser.input
			newa = []
			x.each_with_index do |color, index|
				if x[index] != @coder_colours[index]
					newa << index
				elsif x[index] == @coder_colours[index]
					@block.add_to_block("C")
					$match << (index)
				end
			end

			new_comp = []
			new_human = []

			newa.each do |index|
				new_comp << @coder_colours[index]
				new_human << x[index]
			end

			banned = []
			new_human.each_with_index do |color, index|
				if new_comp.include? color
					unless banned.include? color
						@block.add_to_block("I")
						banned << color
					end
				end
			end
			@block.print_block
			check_win
			@block.reset_block
			if i == 12
				puts "-------------------------------"
				puts "the code was: #{@coder_colours}"
				puts "#{@guesser.name} loses!\n"
				@coder.wins += 1
				puts "-------------------------------"
				puts "#{@guesser.name} wins: #{@guesser.wins}"
				puts "#{@coder.name} wins: #{@coder.wins}\n"
				puts "-------------------------------"
				play_again?
			end
		end
	end
end

game = Game.new("Mike Wazowski")