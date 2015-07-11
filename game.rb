require './board'

class Game
  UP = 0
  RIGHT = 1
  DOWN = 2
  LEFT = 3

  attr_reader :board, :game_state, :direction
  def initialize
    @board = Board.new
    @direction = 1
    @game_state = [
      [0, [2, 2]],
      [1, [2, 3]],
      [2, [2, 4]],
      [3, [2, 5]],
      [4, [2, 6]],
      [5, [2, 7]],
      [6, [2, 8]],
      [7, [2, 9]]
    ]
  end

  def move_position(position)
    row, col = position
    case @direction
    when UP
      [row - 1, col]
    when RIGHT
      [row, col + 1]
    when DOWN
      [row + 1, col]
    when LEFT
      [row, col - 1]
    end
  end

  def update_state
    *state, head = game_state
    (0..game_state.length-2).each do |i|
      i, _ = state[i]
      state[i] = [i, game_state[i + 1].last]
    end

    index, position = head
    moved_pos = move_position(position)
    @game_state = state.concat([[index, moved_pos]])
  end

  def died?
    _, position = @game_state.last
    row, col = position

    @playing = false if (row < 2 || row > board.rows - 2)
    @playing = false if (col < 2 || col > board.cols - 2)
  end

  def game_interval!
    sleep(0.2) if [RIGHT, LEFT].include?(direction)
    sleep(0.25) if [UP, DOWN].include?(direction)
  end

  def play!
    @playing = true

    Thread.new {
      while true
        @direction = board.read_command
      end
    }

    while @playing
      update_state
      died?
      game_interval!
      board.print_world(game_state)
    end
  end
end

Game.new.play!
