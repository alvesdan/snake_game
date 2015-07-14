class Snake
  attr_reader :state, :board
  def initialize(board)
    @board = board
    @state = [
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

  def move!(direction)
    *tail, head = state
    (0..state.length-2).each do |i|
      i, _ = tail[i]
      tail[i] = [i, state[i + 1].last]
    end

    index, position = head
    moved = update_position(position, direction)
    @state = tail.concat([[index, moved]])
  end

  def died?
    _, position = state.last
    row, col = position
    across_rows_limit?(row) || across_cols_limit?(col)
  end

  def eat?(apple)
    eat = used_positions.include?(apple.position)
    apple.move(self) if eat
    eat
  end

  def grow!(direction)
    last_state = @state.last
    index, pos = last_state
    moved = update_position(pos, direction)
    @state.concat([[index + 1, moved]])
  end

  def used?(position)
    used_positions.include?(position)
  end

  private

  def update_position(position, direction)
    row, col = position
    case direction
    when UP then [row - 1, col]
    when RIGHT then [row, col + 1]
    when DOWN then [row + 1, col]
    when LEFT then [row, col - 1]
    end
  end

  def across_rows_limit?(row)
    (row < 2 || row > board.height - 1)
  end

  def across_cols_limit?(col)
    (col < 2 || col > board.width - 1)
  end

  def used_positions
    state.map { |s| s.last }
  end
end
