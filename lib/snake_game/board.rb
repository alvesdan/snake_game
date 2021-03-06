require 'io/console'
require 'curses'
require 'colorize'
require_relative 'command'

module SnakeGame
  class Board
    include Command

    attr_reader :rows, :cols, :height, :width
    def initialize
      @rows, @cols = STDOUT.winsize
      @height = @rows - 2
      @width = @cols

      Curses.noecho
      Curses.stdscr.keypad(true)
    end

    def print_world!(game)
      clear_world! and
        draw_board! and
        draw_apple!(game.apple) and
        draw_stats!(game.counter, game.points)

      game.snake.state.each do |state|
        index, pos = state
        head = (index == game.snake.state.length - 1)
        print_snake(game.direction, pos, head: head)
      end

      move_cursor(rows, cols)
    end

    private

    def clear_world!
      move_cursor(1, 1)
      rows.times { write(" " * cols) }
    end

    def move_cursor(row, col)
      write("\e[#{row};#{col}H")
    end

    def write(text)
      STDOUT.write(text)
    end

    def draw_stats!(speed, points)
      move_cursor(rows, 0)
      write("SPEED: #{speed + 1} │ POINTS: #{points}")
    end

    def draw_apple!(apple)
      row, col = apple.position
      move_cursor(row, col)
      write("❤")
    end

    def draw_board!
      # Left and right border
      (0..height).each do |i|
        move_cursor(i, 0) and write("│")
        move_cursor(i, cols) and write("│")
      end

      # Top and bottom border
      (0..cols).each do |i|
        move_cursor(0, i) and write("─")
        move_cursor(height, i) and write("─")
      end

      # Corners
      move_cursor(0, 0) and write("┌")
      move_cursor(0, cols) and write("┐")
      move_cursor(height, 0) and write("└")
      move_cursor(height, cols) and write("┘")
    end

    def snake_head(position)
      case position
      when UP then '∩'
      when RIGHT then '⊃'
      when DOWN then '∪'
      when LEFT then '⊂'
      end
    end

    def print_snake(direction, position, head: false)
      row, col = position
      move_cursor(row, col)
      text = head ? snake_head(direction) : '◆'
      write(text)
    end
  end
end
