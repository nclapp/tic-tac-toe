require 'pry'

class Game
  def initialize
    @starting_board = ["0", "1", "2", "X", "4", "5", "6", "7", "8"]
    @board = @starting_board
    @turns_taken = []
  end

  def start_game
    puts "Welcome to my Tic Tac Toe game!"
    draw_board
    prompt_for_players
    assign_gamepieces
    begin_gameplay
  end

  def draw_board
    # puts "|_#{@board[0]}_|_#{@board[1]}_|_#{@board[2]}_|\n|_#{@board[3]}_|_#{@board[4]}_|_#{@board[5]}_|\n|_#{@board[6]}_|_#{@board[7]}_|_#{@board[8]}_|"
    puts "•———•———•———•"
    puts "| #{@board[0]} | #{@board[1]} | #{@board[2]} |"
    puts "•———+———+———•"
    puts "| #{@board[3]} | #{@board[4]} | #{@board[5]} |"
    puts "•———+———+———•"
    puts "| #{@board[6]} | #{@board[7]} | #{@board[8]} |"
    puts "•———•———•———•"
  end

  def prompt_for_players #TO_I CONVERTS ANY LETTER TO 0, need to fix
    puts "How many players?"
    puts "(0: computer vs. computer; 1: user vs. computer; 2: user vs. user)"
    @num_players = gets.chomp.to_i
    until @num_players.between?(0,2)
      puts "Please pick 0, 1, or 2!"
      @num_players = gets.chomp
    end
    if @num_players == 0
      puts "Get ready to watch a computer vs. computer game!"
    else
      puts "Get ready to play a #{@num_players}-player game!"
    end
  end

  def assign_gamepieces
    if @num_players == 0
      @player_one = "X"
      @player_two = "O"
    end

    if @num_players > 0
      puts "Player 1, what letter would you like to be?"
      @player_one = get_gamepiece_choice
    end

    if @num_players > 1
      puts "Player 2, what letter would you like to be?"
      @player_two = get_gamepiece_choice
      ensure_unique_gamepieces
    end

    if @num_players == 1
      @player_two = "X" if @player_one != "X"
      @player_two = "O" if @player_one == "X"
    end
    puts "Player 1: \"#{@player_one}\""
    puts "Player 2: \"#{@player_two}\""
  end

  def get_gamepiece_choice
    gamepiece_choice = gets.chomp.to_s
    until valid_gamepiece?(gamepiece_choice)
      puts "Please choose a single non-numeric character:"
      gamepiece_choice = gets.chomp.to_s
    end
    gamepiece_choice
  end

  def ensure_unique_gamepieces
    until @player_one != @player_two && valid_gamepiece?(@player_two)
      puts "\"#{@player_two}\" is in use or invalid, please pick another character:"
      @player_two = gets.chomp.to_s
    end
  end

  def valid_gamepiece?(choice) # could break down further into two separate methods
    (choice.length == 1) && !(@board.include?(choice))
  end

  def game_is_won?(current_board)
    [current_board[0], current_board[1], current_board[2]].uniq.length == 1 ||
    [current_board[3], current_board[4], current_board[5]].uniq.length == 1 ||
    [current_board[6], current_board[7], current_board[8]].uniq.length == 1 ||
    [current_board[0], current_board[3], current_board[6]].uniq.length == 1 ||
    [current_board[1], current_board[4], current_board[7]].uniq.length == 1 ||
    [current_board[2], current_board[5], current_board[8]].uniq.length == 1 ||
    [current_board[0], current_board[4], current_board[8]].uniq.length == 1 ||
    [current_board[2], current_board[4], current_board[6]].uniq.length == 1
  end

  # def winner
  #   if game_is_won?

  #   end
  # end

  def all_squares_filled?(current_board)
    [@player_one, @player_two].sort == current_board.uniq.sort
  end

  def begin_gameplay
    puts "Please select your spot."
    until game_is_won?(@board) || all_squares_filled?(@board)
      get_human_spot

      if !game_is_won?(@board) && !all_squares_filled?(@board)
        eval_board
      end

      draw_board
    end
    puts "Game over"
  end

  # PSEUDO CODE, WORKING ON THIS NOW
  # def begin_gameplay
  #   puts "Please select your spot."
  #   until game_is_won?(@board) || all_squares_filled?(@board)
  #     case @num_players
  #     when 0
  #       computer 1 play
  #       computer 2 play
  #     when 1
  #       player_one play
  #       computer play
  #     when 2
  #       player_one play
  #       player_two play
  #     end
  #   end
  #   display_winner
  # end


  def get_human_spot#(player)
    spot = nil
    until spot
      spot = gets.chomp.to_i
      if @board[spot] != @player_one && @board[spot] != @player_two
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
        if @board[spot] != @player_one && @board[spot] != @player_two
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
      if s != @player_one && s != @player_two
        available_spaces << s
      end
    end
    available_spaces.each do |as|
      board[as.to_i] = @com
      if game_is_won?(board)
        best_move = as.to_i
        board[as.to_i] = as
        return best_move
      else
        board[as.to_i] = @hum
        if game_is_won?(board)
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



end#class Game

game = Game.new
# game.start_game
game.draw_board
# game.prompt_for_players
# game.assign_gamepieces
