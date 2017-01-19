##############################################################################################

class Array
  #
  # Return an empty array of the specified width/height
  #
  def self.zeroes(width, height)
    height.times.map { Array.new(width, 0) }
  end

  def hflip
    map &:reverse
  end

  def vflip
    reverse
  end

  def each_xy
    each_with_index do |row, y|
      row.each_with_index { |e, x| yield e, x, y }
    end
  end

  def map_xy
    map.with_index do |row, y|
      row.map.with_index { |e, x| yield e, x, y }
    end
  end

  def rotate(n)
    case n % 4
    when 1
      transpose.hflip # right 90° orthogonal rotation
    when 2
      vflip.hflip     # right (or left) 180° orthogonal rotation
    when 3
      transpose.vflip # right 270° (or left 90°) orthogonal rotation
    else
      self            # no rotation!
    end
  end
end

##############################################################################################

class Buffer

  attr_reader :array, :width, :height

  #
  # Valid arguments are an array of pixels (and an optional hash of translations from characters to other characters, or procs), or the width and height of an empty buffer
  #
  def initialize(array, translations={})
    callables, replacements = translations.partition { |k,v| v.responds_to? :call }.map(&:to_h)

    @array = array
    @array = @array.deep_map { |e| callables[e].call || e } if callables.any?
    @array = @array.deep_map { |e| replacements[e]   || e } if replacements.any?

    update_dimensions!
  end

  def update_dimensions!
    @height = @array.size
    @width  = @array.map(&:size).max
    self
  end

  def size
    width * height
  end

  def self.zeroes(w, h)
    new Array.zeroes(w, h)
  end

  #
  # Rotate in 90-degree increments 'n'-times (positive number for clockwise, negative number for counter-clockwise)
  #
  def rotate!(n)
    @array = @array.rotate(n)
    update_dimensions!
  end

  def rotate(n)
    Buffer.new @array.rotate(n)
  end

  def putpixel(left, top, color)
    @array[top][left] = color if in_bounds?(left, top)
  end

  def blit!(other, top=0, left=0)
    other.array.each_with_index do |row, y|
      row.each_with_index { |c, x| putpixel(x+left, y+top, c) if c != 0 }
    end
  end


  #
  # Render as fat pixels
  #
  def draw!(left=0, top=0)
    @array.each_with_index do |row, y|
      move_to(top+y, left)
      print row.map { |color| color == 0 ? "  " : "<#{color}>██</#{color}>".colorize }.join
    end
    # binding.remote_pry
  end


  def in_bounds?(left, top)
    left >= 0 and top >= 0 and left < @width and top < @height
  end

  #
  # Test if there's a pixel overlap
  #
  def pixel_collision?(other, left=0, top=0)
    other.array.each_xy do |color, x, y|
      # collision when both pixels aren't blank (0)
      ax = left + x
      ay = top + y
      return true if color != 0 and in_bounds?(ax, ay) and @array[y][x] != 0
    end
    false
  end


  # def collides_with?(other)
  #   xcoll = self.left < other.right && other.left < self.right
  #   ycoll = self.top <= other.bottom && other.top <= self.bottom
  #   xcoll && ycoll
  # end

end