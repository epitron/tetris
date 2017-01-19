##############################################################################################
require_relative 'piece'
require_relative 'buffer'
require_relative 'drawing'
##############################################################################################

class Board
  attr_accessor :width, :height

  def initialize(width=15, height=15)
    @buf = Buffer.zeroes(width, height)
  end

  def width;  @buf.width; end
  def height; @buf.height; end

  def draw!
    @buf.draw!
  end

  def collides?(piece)
    @buf.pixel_collision?(piece.buf, piece.left, piece.top)
  end

  def blit!(piece)
    @buf.blit!(piece.buf, piece.x, piece.y)
  end

end

