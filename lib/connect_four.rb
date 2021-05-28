# frozen_string_literal: true

class ConnectFourGame
  attr_accessor :board, :player_ordered_list ### to be checked at the end

  def initialize
    @heigth = 6
    @width = 7
    @board = Array.new(@heigth) {Array.new(@width, nil)} #Array.new(@heigth, Array.new(@width))  
    @player_ordered_list = nil
    # random_player_selection(create_player_array)
  end

  def create_player_array
    @player_ordered_list = [Player.new('Player 1', 'O'), Player.new('Player 2', 'X')]
  end

  def random_player_selection(seed = nil)
    seed = rand(0..1) if seed.nil?
    @player_ordered_list = @player_ordered_list.rotate if seed == 1
  end

  def check_free_positions
    solution_array = []
    @board.each_with_index do |x_array, y_iteration|
      x_array.each_with_index do |cell, x_iteration|
        solution_array.push([x_iteration, y_iteration]) if cell.nil?
      end
    end
    solution_array
  end

  def place_token(posn)
    x = posn[0]
    y = posn[1]
    @board[y][x] = @player_ordered_list[0].token
  end

  def acquire_player_choice
    output = nil
    until valid_input?(output)
      puts 'Input x coordinate:'
      x_value = gets.chomp.to_i
      puts 'Input y coordinate:'
      y_value = gets.chomp.to_i
      output = [x_value, y_value]
    end
    output 
  end

  def valid_input?(posn)
    x = posn[0]
    y = posn[1]
    x.between?(0, @width) && x.between?(0, @heigth) && @board[y][x] == nil
  end

  def player_won?
  end

  def switch_player
  end

  def print_board
  end

  def play
  end
end

class Player
  attr_reader :name, :token

  def initialize(name, token)
    @name = name
    @token = token
  end
end

new_game = ConnectFourGame.new
p new_game.board