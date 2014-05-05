require 'mars_rover'

class Rover
  include Mars
  attr_accessor :instructions
  attr_reader :locations

  def initialize
    @rovers = RoverGroup.new
  end

  def execute
    @locations = @rovers.walk(@instructions)
  end
end
