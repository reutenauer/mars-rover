# encoding: UTF-8

module Mars
  ORIENTATIONS = ['N', 'W', 'S', 'E']
  XMAX = 50
  YMAX = 50
  MAXLINE = 100

  # For methods that modify the state of an object, we use the convention that
  # appending an exclamation mark means the object itself is modified; without
  # the exclamation mark, the object is unaffected and a new object is
  # returned.

  # Orientation – North, West, etc.  Specified as a number of right-angle
  # turns, anticlockwise, from North.
  # Used to specify the orientation of the rover.
  class Orientation
    def initialize(letter)
      @angle = ORIENTATIONS.index(letter)
    end

    def to_s
      ORIENTATIONS[@angle]
    end

    def to_i
      @angle
    end

    def to_vector
      move = Vector.new(0, 1)
      @angle.to_i.times { move.rotate! }
      move
    end

    # Rotate by the specified number of 90-degree turns (can be negative)
    # Returns new object
    def rotate(n = 1)
      Orientation.new(ORIENTATIONS.index((@angle + n) % ORIENTATIONS.count))
    end

    # Same thing, for self
    def rotate!(n = 1)
      @angle = (@angle + n) % ORIENTATIONS.count
    end

    def ==(other)
      to_i == other.to_i
    end
  end

  # Points and vectors shared some of the logic; this is their base class
  class PointOrVector
    attr_reader :x, :y

    def initialize(x, y)
      @x = x
      @y = y
    end
  end

  class Point < PointOrVector
    def translate(vector)
      Point.new(@x + vector.x, @y + vector.y)
    end

    def translate!(vector)
      @x += vector.x
      @y += vector.y
    end
  end

  class Vector < PointOrVector
    # Rotate by exactly 90 degrees anticlockwise
    def rotate
      Vector.new(-@y, @x)
    end

    def rotate!
      @x, @y = -@y, @x
    end

    # Opposite vector
    def reverse
      Vector.new(-x, -y)
    end

    def reverse!
      @x, @y = -@x, -@y
    end
  end

  # Our grid.  Mostly used to keep track of “scents” (and to do some validations).
  class Grid
    attr_reader :xmax, :ymax

    def initialize(line)
      dimensions = line.split
      begin
        @xmax = Integer(dimensions[0])
        @ymax = Integer(dimensions[1])
      rescue ArgumentError
        raise BadGrid
      end
      raise BadGrid if @xmax < 0 || @ymax < 0 || @xmax > XMAX || @ymax > YMAX
      @scents = Hash.new
    end

    # A position (or rather a robot at that position) is lost if it is, well,
    # outside the grid
    def lost?(pos)
      pos.x < 0 || pos.y < 0 || pos.x > @xmax || pos.y > @ymax
    end

    def get_scents(position)
      @scents[[position.x, position.y]] || []
    end

    # A scent actually needs both a position and an orientation;
    # in few cases (the four corners), more than one direction may be “cursed”,
    # so we’re making that an array.
    # We could use a Set from the standard library, but the interface is not
    # that nice and Array does the job just as well.
    def set_scent(position, direction)
      p = [position.x, position.y]
      @scents[p] ||= []
      @scents[p] << direction
    end

    # Here be dragons?
    def cursed?(position, direction)
      get_scents(position).include?(direction)
    end
  end

  # We’re making one class that will execute the whole set of instructions; it
  # is thus a group of rovers rather than a single one.  May change in the
  # future.
  class RoverGroup
    def walk(instructions)
      locations = ""
      lines = instructions.split("\n").reverse # reverse so that we can pop
      grid = Grid.new(lines.pop)
      while lines.count > 0 do
        start = lines.pop.split
        program = lines.pop
        raise TooManyInstructions if start.length > MAXLINE || program.length > MAXLINE
        x = Integer(start[0])
        y = Integer(start[1])
        pos = Point.new(x, y)
        dir = Orientation.new(start[2].strip)
        program.each_char do |letter|
          case letter
          when 'L'
            dir.rotate!
          when 'R'
            dir.rotate!(-1)
          when 'F'
            next if grid.cursed?(pos, dir)
            pos.translate!(dir.to_vector)
            if grid.lost?(pos)
              lastpos = pos.translate(dir.to_vector.reverse)
              grid.set_scent(lastpos, dir)
              locations += "#{lastpos.x} #{lastpos.y} #{dir.to_s} LOST\n"
              break
            else
            end
          end
        end
        locations += "#{pos.x} #{pos.y} #{dir.to_s}\n" unless grid.lost?(pos)
      end

      locations
    end
  end

  class BadGrid < Exception
  end

  class TooManyInstructions < Exception
  end
end
