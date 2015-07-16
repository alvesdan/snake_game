require_relative 'board'
require_relative 'snake'
require_relative 'apple'

module SnakeGame
  UP = 0
  RIGHT = 1
  DOWN = 2
  LEFT = 3

  class Game
    attr_reader :board, :snake, :direction, :apple, :points, :speed
    def initialize
      @direction = RIGHT
      @board = Board.new
      @apple = Apple.new(board)
      @snake = Snake.new(board)
      @points = 0
      @speed = 0
      @counter = 0
    end

    def play!
      @playing = true

      keyboard = Thread.new {
        loop do
          dir = board.read_command
          next unless direction_allowed?(dir)
          @direction = dir
        end
      }

      while @playing
        if snake.eat?(apple)
          snake.grow!(direction)
          add_points!
          increase_speed!
        end

        snake.move!(direction)
        snake.died? and @playing = false
        game_interval!
        board.print_world!(self)
      end

      Thread.kill(keyboard)
    end

    private

    def add_points!
      @points += (1 * @counter += 1)
    end

    def increase_speed!
      @speed += 0.0005
    end

    def game_interval!
      sleep([0.1 - @speed, 0].max)
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
  end
end
