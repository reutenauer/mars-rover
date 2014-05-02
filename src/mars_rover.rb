module Mars
  ORIENTATIONS = ['N', 'W', 'S', 'E']
  XMAX = 50
  YMAX = 50
  MAXLINE = 100

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

    def rotate(n = 1)
      Orientation.new(ORIENTATIONS.index((@angle + n) % ORIENTATIONS.count))
    end

    def rotate!(n = 1)
      @angle = (@angle + n) % ORIENTATIONS.count
    end

    def ==(other)
      to_i == other.to_i
    end
  end

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
    def rotate
      Vector.new(-@y, @x)
    end

    def rotate!
      @x, @y = -@y, @x
    end

    def reverse
      Vector.new(-x, -y)
    end

    def reverse!
      @x, @y = -@x, -@y
    end
  end

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

    def lost?(pos)
      pos.x < 0 || pos.y < 0 || pos.x > @xmax || pos.y > @ymax
    end

    def get_scents(position)
      @scents[[position.x, position.y]] || []
    end

    def set_scent(position, direction)
      p = [position.x, position.y]
      @scents[p] ||= []
      @scents[p] << direction
    end

    def cursed?(position, direction)
      get_scents(position).include?(direction)
    end
  end

  class RoverGroup
    def walk(instructions)
      locations = ""
      lines = instructions.split("\n").reverse
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
