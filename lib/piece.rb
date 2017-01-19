##############################################################################################
require_relative 'drawing'
##############################################################################################

class Piece

  #------------------------------------------------------------
  attr_accessor :top, :left, :width, :height, :buf
  #------------------------------------------------------------

  def initialize(a, color, left=0, top=0)
    @buf  = Buffer.new(a, "x" => color, " " => 0)
    @left = left
    @top  = top
  end

  #------------------------------------------------------------

  alias_method :x, :left
  alias_method :y, :top

  def right;  @left + (@width); end
  def bottom; @top + (@height); end

  def width;  @buf.width; end
  def height; @buf.height; end

  #------------------------------------------------------------

  def rotate!(n)
    @buf.rotate!(n)
  end

  def drop!(n=1)
    @top += n
  end

  def drop(n=1)
    dup.tap &:drop!
  end

  #------------------------------------------------------------

  def to_s
    @a.map { |row| row.join }.join("\n")
  end

  #------------------------------------------------------------

  PIECE_TEMPLATES = [
    ["xxxx"] => :light_cyan,

    ["xx",
     "xx"]   => :light_yellow,

    [" x ",
     "xxx"]  => :light_purple,

    ["x   ",
     "xxxx"] => :blue,

    ["   x",
     "xxxx"] => :yellow,

    ["xx ",
     " xx"]  => :light_red,

    [" xx",
     "xx "]  => :light_green,
  ]

  def self.all
    @@all ||= PIECE_TEMPLATES.map do |a, color|
      Piece.new(a, color, 0, 0)
    end
  end

  #------------------------------------------------------------

  def self.randomized_set
    all.shuffle
  end

  #------------------------------------------------------------

  # def draw!
  #   @a.each_with_index do |row, delta_y|
  #     move_to(@top+delta_y, @left)
  #     puts row.join
  #   end
  # end

  # def each_xy
  #   @a.each_with_index do |row, y|
  #     row.each_with_index do |char, x|
  #       yield x + @left, y + @top, char
  #     end
  #   end
  # end

end
