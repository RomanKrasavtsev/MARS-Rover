#!/usr/bin/env ruby

require './rovers.rb'

RSpec.describe Rover do
  it "check the result" do
    plateau = Plateau.new(5, 5)
    rover1 = Rover.new(1, 2, "N", "LMLMLMLMM")
    rover2 = Rover.new(3, 3, "E", "MMRMMRMRRM")

    rover1.move(plateau)
    rover2.move(plateau)

    expect(rover1.get_current_position).to eq("1 3 N\n")
    expect(rover2.get_current_position).to eq("5 1 E\n")
  end
end
