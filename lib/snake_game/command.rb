module SnakeGame
  module Command
    def read_command
      case Curses.getch
      when Curses::KEY_UP; then UP;
      when Curses::KEY_DOWN; then DOWN;
      when Curses::KEY_RIGHT; then RIGHT;
      when Curses::KEY_LEFT; then LEFT;
      else
        exit
      end
    end
  end
end
