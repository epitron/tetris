##############################################################################################
require_relative 'board'
require_relative 'bag'
require_relative 'drawing'
require_relative 'keymap'
##############################################################################################

class Game

public # The public API is to be used by the Keymapper to implement game commands

  def initialize
    @board = Board.new
    @bag   = Bag.new
  end

  def keymap(&block)
    @keymap = KeyMap.new(&block)
  end

  ##
  ## Keymappable game-control commands
  ##

  def quit!
    show_cursor
    exit 1
  end

  def left!
    @current.dup.left!
    @current.with(left: @current.left - 1) if @current.left > 0
  end

  def right!
    @current = @current.with(left: @current.left + 1) if @current.right < @board.width
  end

  def rotate!(n)
    move = @current.rotate(n)
    @current = move unless @board.collides?(move)
  end

  def drop_now!
    @current.drop! if can_drop?
  end

  def drop_all_the_way!
    while can_drop?
      @current.drop!
    end
  end


# Private API (the game logic)
private

  def can_drop?
    next_position = @current.drop

    !( @board.collides?(next_position) or next_position.bottom > @board.height )
  end

  def next_piece!
    piece = @bag.take_piece!
    @current = piece.with(top: 0, left: rand(@board.width - piece.width)) # position the piece on the board
  end

  def draw!
    @board.draw!
    @current.draw!
    println "Score: #{@score}"
    print "Next piece:"
    @bag.peek

    move_to_row(@board.height)
  end


public

  def play!
    raise "Error: No Keymap" unless @keymap

    #------------------------------------------------------
    keyboard_thread = Thread.new do
      STDIN.raw do |input|
        @keymap.process(input)
      end
    end

    #------------------------------------------------------
    game_loop_thread = Thread.new do
      clear; hide_cursor

      next_piece!

      loop do
        if can_drop?
          @current.drop!
        else
          @board.blit! @current
          next_piece!

          if @board.collides?(@current)
            draw!

            puts "GAME OVER"
            show_cursor

            break
          end
        end

        draw!
        sleep 0.1
      end
    end

    #------------------------------------------------------
    # Yield control of the program to the keyboard thread.
    keyboard_thread.join
  end

end