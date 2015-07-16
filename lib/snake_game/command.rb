module SnakeGame
  module Command
    def read_command
      case read_char
      when "\e[A"; then 0;
      when "\e[B"; then 2;
      when "\e[C"; then 1;
      when "\e[D"; then 3;
      else
        exit
      end
    end

    private

    def read_char
      STDIN.echo = false
      STDIN.raw!

      input = STDIN.getc.chr
      if input == "\e"
        input << STDIN.read_nonblock(3) rescue nil
        input << STDIN.read_nonblock(2) rescue nil
      end

      input
    ensure
      STDIN.echo = true
      STDIN.cooked!
      return input
    end
  end
end
