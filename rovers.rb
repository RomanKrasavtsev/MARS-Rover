#!/usr/bin/env ruby

# Messages
PLATEAU_SIZE = "Set the upper-right coordinates of a plateau:\n"
PLATEAU_SIZE_ERROR = "You should set the upper-right X and Y coordinates!\n"
ROVER_START_POINT = "Set X and Y coordinates of start point and direction of a rover or press ENTER for result:\n"
ROVER_COMMANDS = "Set commands for the rover:\n"
COMMAND_ERROR = "Unknow command!\n"
ROVER_START_POINT_ERROR = "There is a problem with start point or position!\n"
ROVER_POSITION_ERROR = "This position is unavalable!\n"
RESULT = "Result:\n"

class Plateau
  def initialize(x, y)
    @field = Array.new(y + 1) {Array.new(x + 1, true)}
  end

  def available?(x, y)
    if (x >= 0) and (y >= 0) and (x <= @field[0].size - 1) and (y <= @field.size - 1) and (@field[y][x])
      return true
    else
      return false
    end
  end

  def rid(x, y)
    @field[y][x] = true
  end

  def occupy(x, y)
    @field[y][x] = false
  end
end

class Rover
  def initialize(x, y, direction, commands)
    @x = x
    @y = y
    @direction = direction
    @commands = commands
  end

  def move(plateau)
    @commands.upcase.gsub("\n","").split("").each do |command|
      case command
      when "L"
        turn_left
      when "R"
        turn_right
      when "M"
        go_straight(plateau)
      else
        puts COMMAND_ERROR
        exit
      end
    end
  end

  def turn_left
    case @direction
    when "N"
      @direction = "W"
    when "S"
      @direction = "E"
    when "W"
      @direction = "S"
    when "E"
      @direction = "N"
    end
  end

  def turn_right
    case @direction
    when "N"
      @direction = "E"
    when "S"
      @direction = "W"
    when "W"
      @direction = "N"
    when "E"
      @direction = "S"
    end
  end

  def go_straight(plateau)
    case @direction
    when "N"
      if plateau.available?(@x, @y + 1)
        plateau.rid(@x, @y)
        @y += 1
        plateau.occupy(@x, @y)
      end
    when "S"
      if plateau.available?(@x, @y - 1)
        plateau.rid(@x, @y)
        @y -= 1
        plateau.occupy(@x, @y)
      end
    when "W"
      if plateau.available?(@x - 1, @y)
        plateau.rid(@x, @y)
        @x -= 1
        plateau.occupy(@x, @y)
      end
    when "E"
      if plateau.available?(@x + 1, @y)
        plateau.rid(@x, @y)
        @x += 1
        plateau.occupy(@x, @y)
      end
    end
  end

  def get_current_position
    return "#{@x} #{@y} #{@direction}\n"
  end
end

# Set plateau
puts PLATEAU_SIZE
line = gets().split(" ").map{ |i| i.to_i }
if (line.size == 2) && (line[0] >= 0) && (line [1] >= 0)
  x, y = line
  plateau = Plateau.new(x, y)
else
  puts PLATEAU_SIZE_ERROR
  exit
end

# Set rover(s)
rovers = []
while ((puts ROVER_START_POINT; line = gets()) != "\n")
  if (line.split(" ").size == 3)
    x, y, direction = line.split(" ")
    x = x.to_i
    y = y.to_i

    if (plateau.available?(x, y))
      plateau.occupy(x, y)

      puts ROVER_COMMANDS
      commands = gets()

      rover = Rover.new(x, y, direction, commands)
      rovers << rover
    else
      puts ROVER_POSITION_ERROR
      exit
    end
  else
    puts ROVER_START_POINT_ERROR
    exit
  end
end

puts RESULT
rovers.each do |rover|
  rover.move(plateau)
  puts rover.get_current_position
end
