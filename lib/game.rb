require_relative 'board'

class Game
  UP = 0
  RIGHT = 1
  DOWN = 2
  LEFT = 3

  attr_reader :board, :game_state, :direction, :apple, :points, :speed
  def initialize
    @board = Board.new
    @direction = 1
    @apple = [board.height - 4, board.width - 4]
    @points = 0
    @speed = 0
    @counter = 1
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

  def play!
    @playing = true

    Thread.new {
      loop do
        dir = board.read_command
        next unless direction_allowed?(dir)
        @direction = dir
      end
    }

    while @playing
      eat_apple?
      update_state
      died?
      game_interval!
      board.print_world(self)
    end
  end

  private

  def create_apple
    begin
      apple = [rand(board.height - 4) + 2, rand(board.width - 4) + 2]
    end while used_positions.include?(apple)
    apple
  end

  def grow_snake
    state = game_state.last
    index, pos = state
    moved = move_position(pos)
    @game_state.concat([[index + 1, moved]])
  end

  def eat_apple?
    if used_positions.include?(@apple)
      @points += 1 * @counter
      @counter += 1
      @speed += 0.0005
      grow_snake
      @apple = create_apple
    end
  end

  def used_positions
    game_state.map do |state|
      state.last
    end
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

    if across_rows_limit?(row)||
      across_cols_limit?(col)
      @playing = false
    end
  end

  def game_interval!
    sleep(0.1 - @speed)
  end

  def direction_allowed?(dir)
    allowed = case @direction
    when UP, DOWN
      [LEFT, RIGHT]
    when LEFT, RIGHT
      [UP, DOWN]
    end
    allowed.include?(dir)
  end

  def across_rows_limit?(row)
    (row < 2 || row > board.height - 1)
  end

  def across_cols_limit?(col)
    (col < 2 || col > board.width - 1)
  end
end
