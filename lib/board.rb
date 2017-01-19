##############################################################################################
require_relative 'piece'
require_relative 'drawing'
##############################################################################################

#
# logic:
# 1. put piece on board
# 2. if it's colliding immediately, you lose
# 3. move piece down until it hits another piece, or the bottom row
#
class Board
  attr_accessor :width, :height

  def initialize(width=15, height=15)
    @width, @height = width, height

    @field = height.times.map { Array.new(width, " ") }
  end

  def draw!
    move_to(0,0)
    @field.each do |row|
      print row.join; newline
    end
  end

  def collides?(piece)
    # @pieces.any? { |other| piece.collides_with?(other) }
    piece.each_xy do |x,y,char|
      if (fchar = @field[y][x] rescue "x") and fchar != " " and char != " "
        return true
      end
    end
    false
  end

  def blit!(piece)
    piece.each_xy do |x, y, char|
      @field[y][x] = char unless char == " "
    end
  end

end

