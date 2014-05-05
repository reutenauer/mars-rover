class RoversController < ApplicationController
  def start
    @rover = Rover.new
  end

  def execute
    @rover = Rover.new
    @rover.instructions = params[:rover][:instructions]
    @rover.execute
  end
end
