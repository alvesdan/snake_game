require 'io/console'
require 'colorize'
require_relative 'command'

class Board
  include Command

  attr_reader :rows, :cols, :height, :width
  def initialize
    @rows, @cols = STDOUT.winsize
    @height = @rows - 2
    @width = @cols
  end

  def print_world!(game)
    clear_world! and
      draw_board! and
      draw_apple!(game.apple) and
      draw_stats!(game.speed, game.points)

    game.snake.state.each do |state|
      index, pos = state
      head = (index == game.snake.state.length - 1)
      print_snake(pos, head: head)
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
    write("SPEED: #{speed} / POINTS: #{points}")
  end

  def draw_apple!(apple)
    row, col = apple.position
    move_cursor(row, col)
    write("*")
  end

  def draw_board!
    (0..height).each { |i| move_cursor(i, 0) and write("|") }
    (0..height).each { |i| move_cursor(i, cols) and write("|") }
    (0..cols).each { |i| move_cursor(0, i) and write("=") }
    (0..cols).each { |i| move_cursor(height, i) and write("=") }
  end

  def print_snake(position, head: false)
    row, col = position
    move_cursor(row, col)
    text = head ? '#'.yellow : '#'
    write(text)
  end
end
