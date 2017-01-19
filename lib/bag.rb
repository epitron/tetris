##############################################################################################
require_relative 'piece'
##############################################################################################

class Bag

  def initialize
    @pieces = Piece.randomized_set
  end

  def refill!
    @pieces += Piece.randomized_set
  end

  def take_piece!
    refill! if @pieces.size < 3
    @pieces.shift
  end

  def peek
    @pieces.first
  end

end
