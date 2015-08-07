require 'pry'

class Board
  def initialize
    # @board = ["0", "1", "2", "3", "4", "5", "6", "7", "8"]
    # @com = "X"
    # @hum = "O"
  end
end#class Board

class Game
  def initialize
    @board = ["0", "1", "2", "3", "4", "5", "6", "7", "8"]
    # @com = "X"
    # @hum = "O"
  end

  def prompt_for_players
    puts "How many players? \n(0: computer vs. computer; 1: computer vs. user; 2: user vs. user)"
    @num_players = gets.chomp.to_i
    until @num_players.between?(0,2)
      puts "Please pick 0, 1, or 2!"
      @num_players = gets.chomp.to_i
    end
    puts "Great, get ready for a #{@num_players}-player game!"
  end

  def start_game
    puts "Welcome to my Tic Tac Toe game!"
    prompt_for_gamepiece
    draw_board
    puts "Please select your spot."
    until game_is_over(@board) || tie(@board)
      get_human_spot
      if !game_is_over(@board) && !tie(@board)
        eval_board
      end
      draw_board
    end
    puts "Game over"
  end

  def prompt_for_gamepiece
    puts "Player 1, what letter would you like to be?"
    get_gamepiece_choice
    @player_one = @gamepiece_choice

    puts "Player 2, what letter would you like to be?"
    get_gamepiece_choice
    @player_two = @gamepiece_choice
    ensure_unique_gamepiece

    puts "Player 1: \"#{@player_one}\""
    puts "Player 2: \"#{@player_two}\""
  end

  def get_gamepiece_choice
    @gamepiece_choice = gets.chomp.to_s
    until valid_gamepiece?(@gamepiece_choice)
      puts "Please choose a single non-numeric character:"
      @gamepiece_choice = gets.chomp.to_s
    end
  end

  def ensure_unique_gamepiece
    until @player_one != @player_two && valid_gamepiece?(@player_two)
      puts "\"#{@player_two}\" is in use or invalid, please pick another character:"
      @player_two = gets.chomp.to_s
    end
  end

  def valid_gamepiece?(choice)
    (choice.length == 1) && !(@board.include?(choice))
  end

  def draw_board
    puts "|_#{@board[0]}_|_#{@board[1]}_|_#{@board[2]}_|\n|_#{@board[3]}_|_#{@board[4]}_|_#{@board[5]}_|\n|_#{@board[6]}_|_#{@board[7]}_|_#{@board[8]}_|"
  end

  def get_human_spot
    spot = nil
    until spot
      spot = gets.chomp.to_i
      if @board[spot] != "X" && @board[spot] != "O"
        @board[spot] = @hum
      else
        spot = nil
      end
    end
  end

  def eval_board
    spot = nil
    until spot
      if @board[4] == "4"
        spot = 4
        @board[spot] = @com
      else
        spot = get_best_move(@board, @com)
        if @board[spot] != "X" && @board[spot] != "O"
          @board[spot] = @com
        else
          spot = nil
        end
      end
    end
  end

  def get_best_move(board, next_player, depth = 0, best_score = {})
    available_spaces = []
    best_move = nil
    board.each do |s|
      if s != "X" && s != "O"
        available_spaces << s
      end
    end
    available_spaces.each do |as|
      board[as.to_i] = @com
      if game_is_over(board)
        best_move = as.to_i
        board[as.to_i] = as
        return best_move
      else
        board[as.to_i] = @hum
        if game_is_over(board)
          best_move = as.to_i
          board[as.to_i] = as
          return best_move
        else
          board[as.to_i] = as
        end
      end
    end
    if best_move
      return best_move
    else
      n = rand(0..available_spaces.count)
      return available_spaces[n].to_i
    end
  end

  def game_is_over(b)
    [b[0], b[1], b[2]].uniq.length == 1 ||
      [b[3], b[4], b[5]].uniq.length == 1 ||
      [b[6], b[7], b[8]].uniq.length == 1 ||
      [b[0], b[3], b[6]].uniq.length == 1 ||
      [b[1], b[4], b[7]].uniq.length == 1 ||
      [b[2], b[5], b[8]].uniq.length == 1 ||
      [b[0], b[4], b[8]].uniq.length == 1 ||
      [b[2], b[4], b[6]].uniq.length == 1
  end

  def tie(b)
    b.all? { |s| s == "X" || s == "O" }
  end

end#class Game

game = Game.new
# game.start_game
game.prompt_for_players
