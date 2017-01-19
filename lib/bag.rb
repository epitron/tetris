##############################################################################################
require_relative 'piece'
##############################################################################################

class Bag

  def initialize
    reset!
  end

  def reset!
    @bag = Piece.all.shuffle
  end

  def refill!
    @bag += PIECES.shuffle
  end

  def take_piece!
    @bag += PIECES.shuffle if @bag.size <= 2
    @bag.shift
  end

  def peek
    @bag.first
  end

end
