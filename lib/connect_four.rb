# frozen_string_literal: true

require 'matrix'

class ConnectFourGame
  attr_accessor :board, :player_ordered_list ### to be checked at the end

  def initialize
    @heigth = 7
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
    output = [-1, -1]
    until valid_input?(output)
      puts 'Input x coordinate:'
      output[0] = gets.chomp.to_i
      output[1] = find_y_coordinate(output[0])
      p output
    end
    output
  end

  def find_y_coordinate(posn_x)
    @board.each_with_index do |value, index|
      return index if value[posn_x].nil?
    end
  end

  def valid_input?(posn)
    x = posn[0]
    y = posn[1]
    x.between?(0, @width) && y.between?(0, @heigth) && @board[y][x].nil?
  end

  def player_won?
    token_checked = @player_ordered_list[0].token
    token_sequence = Array.new(4, token_checked)
    tokens_aligned_horizontal?(@board, token_sequence) || tokens_aligned_vertical?(@board, token_sequence) || tokens_aligned_diagonal?(@board, token_sequence)
  end

  def tokens_aligned_horizontal?(matrix, token_sequence)
    matrix.any? { |item| item.each_cons(token_sequence.size).include?(token_sequence) }
  end

  def tokens_aligned_vertical?(matrix, token_sequence)
    transposed_matrix = matrix.dup.transpose
    tokens_aligned_horizontal?(transposed_matrix, token_sequence)
  end

  def diagonals(matrix)
    matrix_proc = (0..matrix.size-4).map do |i|
      (0..matrix.size-1-i).map { |j| matrix[i+j][j] }
    end
    matrix_proc.concat((1..matrix.first.size-4).map do |j|
      (0..matrix.size-j-1).map { |i| matrix[i][j+i] }
    end)
  end

  def rotate90(matrix)
    ncols = matrix.first.size
    matrix.each_index.with_object([]) do |i,a|
      a << ncols.times.map { |j| matrix[j][ncols-1-i] }
    end
  end

  def tokens_aligned_diagonal?(matrix, token_sequence)
    diagonal_matrix = diagonals(matrix)
    diagonal_matrix_opposed = diagonals(rotate90(matrix))
    tokens_aligned_horizontal?(diagonal_matrix, token_sequence) || tokens_aligned_horizontal?(diagonal_matrix_opposed, token_sequence)
  end

  def switch_player
    @player_ordered_list.rotate!
  end

  def print_board
    # width = @board.flatten.max.to_s.size+2
    # puts(@board.transpose.reverse.map { |a| a.map { |i| i.to_s.rjust(width) }.join })
    @board.reverse.each { |r| p r }
  end

  def play
    create_player_array
    switch_player
    print_board
    until player_won? || check_free_positions.empty?
      switch_player
      player_choice = acquire_player_choice
      place_token(player_choice)
      print_board
    end
    if player_won?
      puts "#{@player_ordered_list[0].name} has won the game!"
    else
      puts 'GAME OVER!'
    end
  end
end

class Player
  attr_reader :name, :token

  def initialize(name, token)
    @name = name
    @token = token
  end
end

ConnectFourGame.new.play
