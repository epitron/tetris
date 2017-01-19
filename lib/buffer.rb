##############################################################################################

class Array
  def hflip
    map &:reverse
  end

  def vflip
    reverse
  end
end

##############################################################################################

class Buffer

  attr_accessor :array
  attr_reader :width, :height

  def initialize(array, translations={})
    callables, replacements = translations.partition { |k,v| v.responds_to? :call }.map(&:to_h)

    @array = array
    @array = @array.map { |e| callables[e].call || e } if callables.any?
    @array = @array.map { |e| replacements[e]   || e } if replacements.any?

    update_dimensions!
  end

  def update_dimensions!
    @width  = @array.map(&:size).max
    @height = @array.size
    self
  end

  #
  # See: rotate
  #
  def rotate!(n)
    dup.rotate(n)
  end

  #
  # Rotate in 90-degree increments 'n'-times (positive number for clockwise, negative number for counter-clockwise)
  #
  def rotate(n)
    case n % 4
    when 1
      Buffer.new @array.transpose.hflip # right 90° orthogonal rotation
    when 2
      Buffer.new @array.vflip.hflip     # right (or left) 180° orthogonal rotation
    when 3
      Buffer.new @array.transpose.vflip # right 270° (or left 90°) orthogonal rotation
    else
      self                              # no rotation!
    end
  end

  def blit(other, top=0, left=0)
    other.array.each_with_index do |row, y|
      row.each_with_index { |c, x| @array[y][x] = c unless c == 0 }
    end
  end

  def draw!(left=0, top=0)
    @array.each_with_index do |row, i|
      move_to(left, top + i)
      print row.map { |color| "██".color(color) }.join
    end
  end

  def each_xy
    @array.each_with_index do |row, y|
      row.each_with_index { |color, x| yield color, x, y }
    end
  end

  # def collides_with?(other)
  #   xcoll = self.left < other.right && other.left < self.right
  #   ycoll = self.top <= other.bottom && other.top <= self.bottom
  #   xcoll && ycoll
  # end

end