##############################################################################################
require_relative 'buffer'
require_relative 'bag'
require_relative 'piece'
require_relative 'drawing'
require_relative 'keymap'
##############################################################################################

##############################################################################################
# Initialize Graphics
clear
# hide_cursor
at_exit { show_cursor }
##############################################################################################

class Game

public # The public API is to be used by the Keymapper to implement game commands

  def keymap(&block)
    @keymap = KeyMap.new(&block)
  end

  #--------------------------------------------------------
  # Commands to use in the keymap
  #--------------------------------------------------------

  def new_game!
    @board = Buffer.zeroes(15, 15)
    @bag   = Bag.new

    # @board.putpixel(1,1,:light_cyan)
    # @board.putpixel(10,10,:light_yellow)

    spawn_new_game_loop
  end

  def quit!
    show_cursor
    exit 1
  end

  def left!
    @current_piece.move_x!(-1) if @current_piece.left > 0
  end

  def right!
    @current_piece.move_x!( 1) if @current_piece.right < @board.width
  end

  def rotate!(n)
    move = @current_piece.rotate(n)
    @current_piece = move unless collision?(move)
  end

  def drop_now!
    @current_piece.drop! if can_drop?
  end

  def drop_all_the_way!
    while can_drop?
      @current_piece.drop!
    end
  end


# Private API (the game logic)
private

  def collision?(piece)
    @board.pixel_collision?(piece.buf, piece.left, piece.top)
  end

  def can_drop?
    next_position = @current_piece.drop

    !( collision?(next_position) || next_position.bottom >= @board.height )
  end

  def next_piece!
    piece = @bag.take_piece!
    # put the new piece at the top, at a random x-coordinate
    @current_piece = piece.with(top: 0, left: rand(@board.width - piece.width))
  end

  def draw!
    clear
    @board.draw!
    @current_piece.draw!

    # move_to(@board.height+1)

    # println "Score: #{@score}"
    # print "Next piece:"
    # @bag.peek.draw!(12, @board.height+2)

    # move_to_row(@board.height)
  end

  def cement_piece_in_place!
    @board.blit!(@current_piece.buf, @current_piece.left, @current_piece.top)
  end


  def spawn_new_game_loop
    @game_loop.kill if @game_loop&.alive?

    @game_loop = Thread.new do
      next_piece!

      loop do
        if can_drop?
          @current_piece.drop!
        else
          cement_piece_in_place!
          next_piece!

          if collision?(@current_piece)
            draw!

            puts "GAME OVER"
            break
          end
        end

        draw!
        puts "whee"
        sleep 0.5
      end
    end

    @game_loop.abort_on_exception = true
    @game_loop
  end


public

  def play!
    new_game!
    # pp Bag.new.peek
    # exit

    raise "Error: No Keymap" unless @keymap

    @keyboard_thread = Thread.new do
      STDIN.raw do |input|
        @keymap.process(input)
      end
    end

    # Yield control of the program to the keyboard thread. (When it goes, we go.)
    @keyboard_thread.join
  end

end