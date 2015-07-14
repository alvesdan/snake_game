class Apple
  attr_reader :position, :board
  def initialize(board)
    @board = board
    @position = [board.height - 4, board.width - 4]
  end

  def move(snake)
    begin
      moved = [
        rand(board.height - 4) + 2,
        rand(board.width - 4) + 2
      ]
    end while snake.used?(moved)
    @position = moved
  end
end
