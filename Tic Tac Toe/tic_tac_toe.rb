class Table
	attr_accessor :table

	def initialize
		@table = [
			["-","-","-"],
			["-","-","-"],
			["-","-","-"]
		]
	end

	def do_table
		@table.each_index do |i|
			subtable = @table[i]
			subtable.each do |x|
				print "| #{x} |"
			end
			print "\n"
		end
	end

	def reset_table
		@table = [["-","-","-"],["-","-","-"],["-","-","-"]]
	end
end

class Player
	attr_reader :name, :value
	attr_accessor :wins

	def initialize(name, value)
		@name = name
		@value = value
		@wins = 0
	end

	def turn(table)
		while i = gets.chomp.split(",")
			if i[0].to_i > 2 || table.table[i[0].to_i][i[1].to_i] != "-"
				puts "Error!"
				print "#{name}'s turn for #{value}: "
			else
				table.table[i[0].to_i][i[1].to_i] = @value
				break
			end
		end
	end
end

class Game
	def initialize
		print "Player 1 Name: "
		input = gets.chomp
		@player1 = Player.new(input, :X)
		print "Player 2 Name: "
		input = gets.chomp
		@player2 = Player.new(input, :O)

		@table = Table.new
		@table.do_table

		@whos_turn = 0
		@win_val = nil

		game_loop
	end

	private

	def game_loop
		while true
			case @whos_turn
			when 0
				print "#{@player1.name}'s turn for #{@player1.value}, 'x,y': "
				@player1.turn(@table)
				check_win(@player1)
			when 1
				print "#{@player2.name}'s turn for #{@player2.value}, 'x,y':  "
				@player2.turn(@table)
				check_win(@player2)
			end
			@table.do_table
			swap_turn
		end
	end

	def swap_turn
		if @whos_turn == 1
			@whos_turn = 0
		else
			@whos_turn = 1
		end
	end

	#Need to refactor this soon!
	def check_win(player)
		if (@table.table[0][0] == player.value && @table.table[0][1] == player.value && @table.table[0][2] == player.value) ||
		   (@table.table[1][0] == player.value && @table.table[1][1] == player.value && @table.table[1][2] == player.value) ||
		   (@table.table[2][0] == player.value && @table.table[2][1] == player.value && @table.table[2][2] == player.value) ||
		   (@table.table[0][0] == player.value && @table.table[1][0] == player.value && @table.table[2][0] == player.value) ||
		   (@table.table[0][0] == player.value && @table.table[1][0] == player.value && @table.table[2][0] == player.value) ||
		   (@table.table[0][1] == player.value && @table.table[1][1] == player.value && @table.table[2][1] == player.value) ||
		   (@table.table[0][2] == player.value && @table.table[1][2] == player.value && @table.table[2][2] == player.value) ||
		   (@table.table[0][0] == player.value && @table.table[1][1] == player.value && @table.table[2][2] == player.value) ||
		   (@table.table[2][0] == player.value && @table.table[1][1] == player.value && @table.table[0][2] == player.value) 
			@win_val = player.value
			game_end
		end
	end

	def game_end
		if @player1.value == @win_val
			puts "#{@player1.name} wins!"
			@player1.wins += 1
		elsif @player2.value == @win_val
			puts "#{@player2.name} wins!"
			@player2.wins += 1
		elsif "Draw" == @win_val
			puts "Game was a draw."
		end
		puts "#{@player1.name} wins: #{@player1.wins} / #{@player2.name} wins: #{@player2.wins}"
		play_again?
	end

	def play_again?
		puts "Type 'new' for new game, or 'rematch' to play again!"
		input = gets.chomp.downcase
		Game.new if input == "new"
		if input == "rematch"
			@table.reset_table
			game_loop
		end
	end
end

game = Game.new