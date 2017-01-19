##############################################################################################
require_relative 'drawing'
##############################################################################################

class Piece

  #------------------------------------------------------------

  attr_accessor :left, :top, :buf

  def initialize(a, color, left=0, top=0)
    @left, @top = left, top
    @buf = Buffer.new(a, "x" => color, " " => 0)
  end

  #------------------------------------------------------------

  def width;  @buf.width; end
  def height; @buf.height; end

  def right;  @left + width; end
  def bottom; @top + height; end

  alias_method :x, :left
  alias_method :y, :top

  #------------------------------------------------------------

  PIECE_TEMPLATES = {
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
  }

  def self.all
    @@all ||= PIECE_TEMPLATES.map do |a, color|
      new(a.map(&:chars), color)
    end
  end

  #------------------------------------------------------------
  def move_x!(dx)
    @left += dx
  end

  def rotate(n)
    dup.rotate!(n)
  end

  def rotate!(n)
    @buf.rotate!(n)
    self
  end

  def drop!(n=1)
    @top += n
  end

  def drop(n=1)
    dup.tap &:drop!
  end

  #------------------------------------------------------------

  def self.randomized_set
    all.shuffle
  end

  #------------------------------------------------------------

  def draw!
    @buf.draw!(left, top)
  end

  #------------------------------------------------------------

  def to_s
    @a.map { |row| row.join }.join("\n")
  end

end
