# frozen_string_literal: true

require_relative '../lib/connect_four'
require 'json'

describe ConnectFourGame do
  subject(:new_game) { described_class.new }
  subject(:player_1) { Player.new('Player 1', 'O') }
  subject(:player_2) { Player.new('Player 2', 'X') }

  describe '#create_player_array' do
    it 'Returns a player array with player 1 and 2' do
      new_game.create_player_array
      solution = new_game.player_ordered_list.length
      expect(solution).to eq(2)
    end
    it 'Player array first position is player 1' do
      new_game.create_player_array
      solution = new_game.player_ordered_list[0].name
      expect(solution).to eql(player_1.name)
    end
    it 'Player array second position is player 2' do
      new_game.create_player_array
      solution = new_game.player_ordered_list[1].name
      expect(solution).to eql(player_2.name)
    end
  end

  describe '#random_player_selection' do
    it 'Returns a player 1 in first position with seed 0' do
      new_game.create_player_array
      new_game.random_player_selection(0)
      solution = new_game.player_ordered_list[0].name
      expect(solution).to eq(player_1.name)
    end
    it 'Returns a player 2 in first position with seed 1' do
      new_game.create_player_array
      new_game.random_player_selection(1)
      solution = new_game.player_ordered_list[0].name
      expect(solution).to eq(player_2.name)
    end
  end

  describe '#check_free_positions' do
    it 'Returns the full array of positions if no play has been made' do
      solution = new_game.check_free_positions - (0..6).to_a.product((0..6).to_a)
      expect(solution).to eq([])
    end
    it 'Returns a partial array if a few plays have been made' do
      new_game.board = [[nil, 'X', 'X', 'X', 'X', 'X', 'X'],
                        ['X', nil, 'X', 'X', 'X', 'X', 'X'],
                        ['X', 'X', nil, 'X', 'X', 'X', 'X'],
                        ['X', 'X', 'X', nil, 'X', 'X', 'X'],
                        ['X', 'X', 'X', 'X', nil, 'X', 'X'],
                        ['X', 'X', 'X', 'X', 'X', nil, 'X'],
                        ['X', 'X', 'X', 'X', 'X', 'X', nil]]
      solution = new_game.check_free_positions
      expect(solution).to eq([[0, 0], [1, 1], [2, 2], [3, 3], [4, 4], [5, 5], [6, 6]])
    end
    it 'Returns nil the array is full' do
      new_game.board = [['X', 'X', 'X', 'X', 'X', 'X', 'X'],
                        ['X', 'X', 'X', 'X', 'X', 'X', 'X'],
                        ['X', 'X', 'X', 'X', 'X', 'X', 'X'],
                        ['X', 'X', 'X', 'X', 'X', 'X', 'X'],
                        ['X', 'X', 'X', 'X', 'X', 'X', 'X'],
                        ['X', 'X', 'X', 'X', 'X', 'X', 'X'],
                        ['X', 'X', 'X', 'X', 'X', 'X', 'X']]
      solution = new_game.check_free_positions
      expect(solution).to eq([])
    end
  end

  describe '#place_token' do
    it 'Add a token at the specified position.' do
      new_game.player_ordered_list = [player_1, player_2]
      new_game.place_token([0, 0])
      solution = new_game.board
      expect(solution).to eq([['O', nil, nil, nil, nil, nil, nil],
                              [nil, nil, nil, nil, nil, nil, nil],
                              [nil, nil, nil, nil, nil, nil, nil],
                              [nil, nil, nil, nil, nil, nil, nil],
                              [nil, nil, nil, nil, nil, nil, nil],
                              [nil, nil, nil, nil, nil, nil, nil],
                              [nil, nil, nil, nil, nil, nil, nil]])
    end
  end

  describe '#acquire_player_choice' do
    before do
      allow(new_game).to receive(:valid_input?).and_return(true)
    end
    it 'Check if #valid_input? receive a signal' do
      expect(new_game).to receive(:valid_input?)
      new_game.acquire_player_choice
    end
  end

  describe '#find_y_coordinate' do
    it 'Returns 0 in case of empty array.' do
      new_game.board = [[nil, nil, nil, nil, nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil]]
      solution = new_game.find_y_coordinate(5)
      expect(solution).to eql(0)
    end
    it 'Returns correct value in case of filled array.' do
      new_game.board = [['X', 'X', 'X', 'X', 'X', 'X', nil],
                        ['X', 'X', 'X', 'X', 'X', nil, nil],
                        ['X', 'X', 'X', 'X', nil, nil, nil],
                        ['X', 'X', 'X', 'X', nil, nil, nil],
                        ['X', 'X', nil, nil, nil, nil, nil],
                        ['X', nil, nil, nil, nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil]]
      solution = new_game.find_y_coordinate(3)
      expect(solution).to eql(4)
    end
  end

  describe '#valid_input?' do
    it 'Check if a valid value with on empty point returns true' do
      new_game.board = [[nil, 'X', 'X', 'X', 'X', 'X', 'X'],
                        ['X', nil, 'X', 'X', 'X', 'X', 'X'],
                        ['X', 'X', nil, 'X', 'X', 'X', 'X'],
                        ['X', 'X', 'X', nil, 'X', 'X', 'X'],
                        ['X', 'X', 'X', 'X', nil, 'X', 'X'],
                        ['X', 'X', 'X', 'X', 'X', nil, 'X'],
                        ['X', 'X', 'X', 'X', 'X', 'X', nil]]
      solution = new_game.valid_input?([1, 1])
      expect(solution).to be true
    end
    it 'Check if a valid value with on empty board returns true' do
      new_game.board = [[nil, nil, nil, nil, nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil]]
      solution = new_game.valid_input?([3, 3])
      expect(solution).to be true
    end
    it 'Check if an invalid value with on empty point returns false' do
      new_game.board = [[nil, 'X', 'X', 'X', 'X', 'X', 'X'],
                        ['X', nil, 'X', 'X', 'X', 'X', 'X'],
                        ['X', 'X', nil, 'X', 'X', 'X', 'X'],
                        ['X', 'X', 'X', nil, 'X', 'X', 'X'],
                        ['X', 'X', 'X', 'X', nil, 'X', 'X'],
                        ['X', 'X', 'X', 'X', 'X', nil, 'X'],
                        ['X', 'X', 'X', 'X', 'X', 'X', nil]]
      solution = new_game.valid_input?([10, 10])
      expect(solution).to be false
    end
    it 'Check if a valid value with on full point returns false' do
      new_game.board = [[nil, 'X', 'X', 'X', 'X', 'X', 'X'],
                        ['X', nil, 'X', 'X', 'X', 'X', 'X'],
                        ['X', 'X', nil, 'X', 'X', 'X', 'X'],
                        ['X', 'X', 'X', nil, 'X', 'X', 'X'],
                        ['X', 'X', 'X', 'X', nil, 'X', 'X'],
                        ['X', 'X', 'X', 'X', 'X', nil, 'X'],
                        ['X', 'X', 'X', 'X', 'X', 'X', nil]]
      solution = new_game.valid_input?([1, 0])
      expect(solution).to be false
    end
  end

  describe '#tokens_aligned_horizontal?' do
    it 'Returns true for an horizontal line' do
      token_sequence = Array.new(4, 'O')
      input_array = [[nil, 'O', 'O', 'O', 'O', nil, nil],
                     [nil, nil, nil, nil, nil, nil, nil],
                     [nil, nil, nil, nil, nil, nil, nil],
                     [nil, nil, nil, nil, nil, nil, nil],
                     [nil, nil, nil, nil, nil, nil, nil],
                     [nil, nil, nil, nil, nil, nil, nil],
                     [nil, nil, nil, nil, nil, nil, nil]]
      solution = new_game.tokens_aligned_horizontal?(input_array, token_sequence)
      expect(solution).to be true
    end
    it 'Returns false for an broken horizontal line' do
      token_sequence = Array.new(4, 'O')
      input_array = [[nil, 'O', 'O', 'O', nil, 'O', nil],
                     [nil, nil, nil, nil, nil, nil, nil],
                     [nil, nil, nil, nil, nil, nil, nil],
                     [nil, nil, nil, nil, nil, nil, nil],
                     [nil, nil, nil, nil, nil, nil, nil],
                     [nil, nil, nil, nil, nil, nil, nil],
                     [nil, nil, nil, nil, nil, nil, nil]]
      solution = new_game.tokens_aligned_horizontal?(input_array, token_sequence)
      expect(solution).to be false
    end
    it 'Returns false for a horizontal line broken by wrong token' do
      token_sequence = Array.new(4, 'O')
      input_array = [[nil, 'O', 'O', 'O', 'X', 'O', nil],
                     [nil, nil, nil, nil, nil, nil, nil],
                     [nil, nil, nil, nil, nil, nil, nil],
                     [nil, nil, nil, nil, nil, nil, nil],
                     [nil, nil, nil, nil, nil, nil, nil],
                     [nil, nil, nil, nil, nil, nil, nil],
                     [nil, nil, nil, nil, nil, nil, nil]]
      solution = new_game.tokens_aligned_horizontal?(input_array, token_sequence)
      expect(solution).to be false
    end
  end

  describe '#tokens_aligned_vertical?' do
    it 'Returns true for an vertical line' do
      token_sequence = Array.new(4, 'O')
      input_array = [[nil, 'O', nil, nil, nil, nil, nil],
                     [nil, 'O', nil, nil, nil, nil, nil],
                     [nil, 'O', nil, nil, nil, nil, nil],
                     [nil, 'O', nil, nil, nil, nil, nil],
                     [nil, nil, nil, nil, nil, nil, nil],
                     [nil, nil, nil, nil, nil, nil, nil],
                     [nil, nil, nil, nil, nil, nil, nil]]
      solution = new_game.tokens_aligned_vertical?(input_array, token_sequence)
      expect(solution).to be true
    end
    it 'Returns false for an broken vertical line' do
      token_sequence = Array.new(4, 'O')
      input_array = [[nil, 'O', nil, nil, nil, 'O', nil],
                     [nil, 'O', nil, nil, nil, nil, nil],
                     [nil, 'O', nil, nil, nil, nil, nil],
                     [nil, nil, nil, nil, nil, nil, nil],
                     [nil, 'O', nil, nil, nil, nil, nil],
                     [nil, nil, nil, nil, nil, nil, nil],
                     [nil, nil, nil, nil, nil, nil, nil]]
      solution = new_game.tokens_aligned_vertical?(input_array, token_sequence)
      expect(solution).to be false
    end
    it 'Returns false for a vertical line broken by wrong token' do
      token_sequence = Array.new(4, 'O')
      input_array = [[nil, 'O', nil, 'O', 'X', 'O', nil],
                     [nil, 'O', nil, nil, nil, nil, nil],
                     [nil, 'O', nil, nil, nil, nil, nil],
                     [nil, 'X', nil, nil, nil, nil, nil],
                     [nil, 'O', nil, nil, nil, nil, nil],
                     [nil, nil, nil, nil, nil, nil, nil],
                     [nil, nil, nil, nil, nil, nil, nil]]
      solution = new_game.tokens_aligned_vertical?(input_array, token_sequence)
      expect(solution).to be false
    end
  end

  describe '#tokens_aligned_diagonal?' do
    it 'Returns true for a diagonal line' do
      token_sequence = Array.new(4, 'X')
      input_array = [['X', nil, nil, nil, nil, nil, nil],
                     ['X', nil, nil, nil, nil, nil, nil],
                     [nil, 'X', nil, nil, nil, nil, nil],
                     [nil, nil, 'X', nil, nil, nil, nil],
                     [nil, nil, nil, 'X', nil, nil, nil],
                     [nil, nil, nil, nil, nil, nil, nil],
                     [nil, nil, nil, nil, nil, nil, nil]]
      solution = new_game.tokens_aligned_diagonal?(input_array, token_sequence)
      expect(solution).to be true
    end
    it 'Returns true for a diagonal line on the other side' do
      token_sequence = Array.new(4, 'X')
      input_array = [[nil, nil, nil, nil, nil, nil, 'X'],
                     [nil, nil, nil, nil, nil, 'X', nil],
                     [nil, nil, nil, nil, 'X', nil, nil],
                     [nil, nil, nil, 'X', nil, nil, nil],
                     [nil, nil, nil, nil, nil, nil, nil],
                     [nil, nil, nil, nil, nil, nil, nil],
                     [nil, nil, nil, nil, nil, nil, nil]]
      solution = new_game.tokens_aligned_diagonal?(input_array, token_sequence)
      expect(solution).to be true
    end
    it 'Returns false for a vertical line broken by wrong token' do
      token_sequence = Array.new(4, 'X')
      input_array = [[nil, nil, nil, nil, nil, nil, 'X'],
                     [nil, nil, nil, nil, nil, 'X', nil],
                     [nil, nil, nil, nil, 'O', nil, nil],
                     [nil, nil, nil, 'X', nil, nil, nil],
                     [nil, nil, 'X', nil, nil, nil, nil],
                     [nil, nil, nil, nil, nil, nil, nil],
                     [nil, nil, nil, nil, nil, nil, nil]]
      solution = new_game.tokens_aligned_diagonal?(input_array, token_sequence)
      expect(solution).to be false
    end
    it 'Returns false for a vertical line broken' do
      token_sequence = Array.new(4, 'X')
      input_array = [[nil, nil, nil, nil, nil, nil, 'X'],
                     [nil, nil, nil, nil, nil, 'X', nil],
                     [nil, nil, nil, nil, nil, nil, nil],
                     [nil, nil, nil, 'X', nil, nil, nil],
                     [nil, nil, 'X', nil, nil, nil, nil],
                     [nil, nil, nil, nil, nil, nil, nil],
                     [nil, nil, nil, nil, nil, nil, nil]]
      solution = new_game.tokens_aligned_diagonal?(input_array, token_sequence)
      expect(solution).to be false
    end
  end

  describe '#player_won?' do
    it 'Returns true for an horizontal line' do
      new_game.create_player_array
      new_game.board = [[nil, 'O', 'O', 'O', 'O', nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil]]
      solution = new_game.player_won?
      expect(solution).to be true
    end
    it 'Returns true for an vertical line line' do
      new_game.create_player_array
      new_game.board = [['O', nil, nil, nil, nil, nil, nil],
                        ['O', nil, nil, nil, nil, nil, nil],
                        ['O', nil, nil, nil, nil, nil, nil],
                        ['O', nil, nil, nil, nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil]]
      solution = new_game.player_won?
      expect(solution).to be true
    end
    it 'Returns true for a diagonal line' do
      new_game.create_player_array
      new_game.board = [['O', nil, nil, nil, nil, nil, nil],
                        [nil, 'O', nil, nil, nil, nil, nil],
                        [nil, nil, 'O', nil, nil, nil, nil],
                        [nil, nil, nil, 'O', nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil]]
      solution = new_game.player_won?
      expect(solution).to be true
    end
    it 'Returns true for a diagonal line on the other side' do
      new_game.create_player_array
      new_game.board = [[nil, nil, nil, nil, nil, nil, 'O'],
                        [nil, nil, nil, nil, nil, 'O', nil],
                        [nil, nil, nil, nil, 'O', nil, nil],
                        [nil, nil, nil, 'O', nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil]]
      solution = new_game.player_won?
      expect(solution).to be true
    end
    it 'Returns false for an empty board' do
      new_game.create_player_array
      new_game.board = [[nil, nil, nil, nil, nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil]]
      solution = new_game.player_won?
      expect(solution).to_not be true
    end
    it 'Returns false for a line with different tokens' do
      new_game.create_player_array
      new_game.board = [[nil, nil, nil, 'O', 'O', 'O', 'X'],
                        [nil, nil, nil, nil, nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil],
                        [nil, nil, nil, nil, nil, nil, nil]]
      solution = new_game.player_won?
      expect(solution).to_not be true
    end
  end

  describe '#switch_player' do
    it 'switch from player 1 to player 2' do
      new_game.player_ordered_list = [player_1, player_2]
      new_game.switch_player
      solution = new_game.player_ordered_list
      expect(solution).to eq([player_2, player_1])
    end
    it 'switch from player 2 to player 1' do
      new_game.player_ordered_list = [player_2, player_1]
      new_game.switch_player
      solution = new_game.player_ordered_list
      expect(solution).to eq([player_1, player_2])
    end
  end
end
