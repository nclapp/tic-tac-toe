require 'pry'

class Game
  def initialize
    @board = ["0", "1", "2", "3", "4", "5", "6", "7", "8"]
    @num_human_players
    @player_one
    @player_two
    @players_in_order = []
    @empty_squares = [] # also declared in #get_empty_squares, has to reset every time
  end

  def start_new_game
    clear_screen
    greet_player
    # draw_board
    prompt_for_players
    assign_gamepieces
    set_player_order
    begin_gameplay
  end

  def clear_screen
    puts "\e[H\e[2J" # probably not work cross-platform
  end

  def greet_player
    puts "WELCOME TO TIC-TAC-TOE!"
    puts "———————————————————————"
  end

  def draw_board
    puts "•———•———•———•"
    puts "| #{@board[0]} | #{@board[1]} | #{@board[2]} |"
    puts "•———+———+———•"
    puts "| #{@board[3]} | #{@board[4]} | #{@board[5]} |"
    puts "•———+———+———•"
    puts "| #{@board[6]} | #{@board[7]} | #{@board[8]} |"
    puts "•———•———•———•"
  end

  def prompt_for_players #TO_I CONVERTS ANY LETTER TO 0, need to fix
    print "Number of human players (0, 1, or 2): "
    @num_human_players = gets.chomp.to_i
    until @num_human_players.between?(0,2)
      print "Please pick 0, 1, or 2: "
      @num_human_players = gets.chomp.to_i
    end
    if @num_human_players == 0
      puts "\nGet ready to watch a computer vs. computer game!\n"
    else
      puts "\nGet ready to play a #{@num_human_players}-player game!"
      puts
    end
    # clear_screen
  end

  def assign_gamepieces
    if @num_human_players == 0
      @player_one = "X"
      @player_two = "O"
    end

    if @num_human_players > 0
      print "Human \#1, pick your letter: "
      @player_one = get_gamepiece_choice
    end

    if @num_human_players > 1
      print "Human \#2, pick your letter: "
      @player_two = get_gamepiece_choice
      ensure_unique_gamepieces
    end

    if @num_human_players == 1 # if 1-player game, player 1 is human, player 2 is computer.
      @player_two = "X" if @player_one != "X"
      @player_two = "O" if @player_one == "X"
    end
    # puts "Player 1: \"#{@player_one}\""
    # puts "Player 2: \"#{@player_two}\""
  end

  def get_gamepiece_choice
    gamepiece_choice = gets.chomp.to_s
    until valid_gamepiece?(gamepiece_choice)
      print "Please choose a single non-numeric character: "
      gamepiece_choice = gets.chomp.to_s
    end
    gamepiece_choice
  end

  def ensure_unique_gamepieces
    until @player_one != @player_two && valid_gamepiece?(@player_two)
      print "\"#{@player_two}\" is in use or invalid, please pick another character: "
      @player_two = gets.chomp.to_s
    end
  end

  def valid_gamepiece?(choice) # could break down further into two separate methods
    (choice.length == 1) && !(@board.include?(choice))
  end

  def swap_player_pieces
    @player_one, @player_two = @player_two, @player_one
  end

  def set_player_order
    default_order = [@player_one, @player_two]
    if @num_human_players == 0
      @players_in_order = default_order
    else
      puts "Who should go first, Player 1 (\"#{@player_one}\") or Player 2 (\"#{@player_two}\")?"
      print "Enter 1 for Player 1, or 2 for Player 2: "
      first_player = gets.chomp.to_i
      case first_player
      when 1
        @players_in_order = default_order
      when 2
        @players_in_order = default_order.reverse
      end
    end
    display_player_order
    # binding.pry
  end

  def display_player_order
    puts "#{@players_in_order[0]} plays first, #{@players_in_order[1]} plays second."
  end

  def begin_gameplay
    # binding.pry
    puts "#{@players_in_order[0]}, please select your spot."
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
  #     case @num_human_players
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

  def random_computer_move

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

  def get_empty_squares(board)
    @empty_squares = []
    board.each do |square|
      if square != @player_one && square != @player_two
        @empty_squares << square
      end
    end
  end

  def get_best_move(board, next_player, depth = 0, best_score = {})
    best_move = nil

    get_empty_squares(board)

    @empty_squares.each do |empty_sq|
      board[empty_sq.to_i] = @com
      if game_is_won?(board)
        best_move = empty_sq.to_i
        board[empty_sq.to_i] = empty_sq
        return best_move
      else
        board[empty_sq.to_i] = @hum
        if game_is_won?(board)
          best_move = empty_sq.to_i
          board[empty_sq.to_i] = empty_sq
          return best_move
        else
          board[empty_sq.to_i] = empty_sq
        end
      end
    end

    if best_move
      return best_move
    else
      n = rand(0..@empty_squares.count)
      return @empty_squares[n].to_i
    end

  end

  #THINGS I'D LIKE TO DO:
  # Divide into Board, Player, and Game classes

end#class Game

game = Game.new
game.start_new_game
# game.draw_board
# game.prompt_for_players
# game.assign_gamepieces
# game.set_player_order
