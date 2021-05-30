# frozen_string_literal: true

require_relative './player'

# Represents on game of connect four
class ConnectFourGame
  attr_accessor :board, :player_ordered_list ### to be checked at the end

  def initialize
    @heigth = 7
    @width = 7
    @board = Array.new(@heigth) {Array.new(@width, nil)}
    @player_ordered_list = nil
  end

  # Create the player array with two players
  def create_player_array
    @player_ordered_list = [Player.new('Player 1', 'O'), Player.new('Player 2', 'X')]
  end

  # Shuffle randomly the player array
  def random_player_selection(seed = nil)
    seed = rand(0..1) if seed.nil?
    @player_ordered_list = @player_ordered_list.rotate if seed == 1
  end

  # Returns an array containing the empty cells. Effectively only used to check if any position remain on the board
  def check_free_positions
    solution_array = []
    @board.each_with_index do |x_array, y_iteration|
      x_array.each_with_index do |cell, x_iteration|
        solution_array.push([x_iteration, y_iteration]) if cell.nil?
      end
    end
    solution_array
  end

  # Consumes a checked position and place it on the board
  def place_token(posn)
    x = posn[0]
    y = posn[1]
    @board[y][x] = @player_ordered_list[0].token
  end

  # Acquire player choice X for the position and deduct the Y coordinate, checks the output.
  def acquire_player_choice
    output = [-1, -1]
    until valid_input?(output)
      puts "#{@player_ordered_list[0].name} input x coordinate:"
      output[0] = gets.chomp.to_i
      output[1] = find_y_coordinate(output[0])
    end
    output
  end

  # Returns the Y coordinate by consuming an X coordinate, check the lowest free Y coordinate on this X point.
  def find_y_coordinate(posn_x)
    @board.each_with_index do |value, index|
      return index if value[posn_x].nil?
    end
    return -1
  end

  #validate that the output is on the board and free
  def valid_input?(posn)
    x = posn[0]
    y = posn[1]
    x.between?(0, @width) && y.between?(0, @heigth) && @board[y][x].nil?
  end

  # Check if the current player has won
  def player_won?
    token_checked = @player_ordered_list[0].token
    token_sequence = Array.new(4, token_checked)
    tokens_aligned_horizontal?(@board, token_sequence) || tokens_aligned_vertical?(@board, token_sequence) || tokens_aligned_diagonal?(@board, token_sequence)
  end

  # Returns true if there is a horizontal line of token for one player
  def tokens_aligned_horizontal?(matrix, token_sequence)
    matrix.any? { |item| item.each_cons(token_sequence.size).include?(token_sequence) }
  end

  # Returns true if there is a vertical line of token for one player
  def tokens_aligned_vertical?(matrix, token_sequence)
    transposed_matrix = matrix.dup.transpose
    tokens_aligned_horizontal?(transposed_matrix, token_sequence)
  end

  # Returns the diagonals of a matrix
  def diagonals(matrix)
    matrix_proc = (0..matrix.size-4).map do |i|
      (0..matrix.size-1-i).map { |j| matrix[i+j][j] }
    end
    matrix_proc.concat((1..matrix.first.size-4).map do |j|
      (0..matrix.size-j-1).map { |i| matrix[i][j+i] }
    end)
  end

  # Rotate a matrix 90°
  def rotate90(matrix)
    ncols = matrix.first.size
    matrix.each_index.with_object([]) do |i,a|
      a << ncols.times.map { |j| matrix[j][ncols-1-i] }
    end
  end

  # Returns true if there is a diagonal line of token for one player
  def tokens_aligned_diagonal?(matrix, token_sequence)
    diagonal_matrix = diagonals(matrix)
    diagonal_matrix_opposed = diagonals(rotate90(matrix))
    tokens_aligned_horizontal?(diagonal_matrix, token_sequence) || tokens_aligned_horizontal?(diagonal_matrix_opposed, token_sequence)
  end

  # Switch player
  def switch_player
    @player_ordered_list.rotate!
  end

  # Print board
  def print_board
    input_board = @board.transpose
    puts "\n"
    6.downto(0) do |i|
      print '    |'
      input_board.each do |column|
        column[i].nil? ? print('   ') : print(" #{column[i]} ")
        print '|'
      end
      puts "\n"
    end
    puts '      0   1   2   3   4   5   6'
  end

  # Main play loop
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
    player_won? ? puts("#{@player_ordered_list[0].name} has won the game!") : puts('GAME OVER!')
  end
end
