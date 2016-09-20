class HumanPlayer
  attr_reader :color, :name
  def initialize(name, color)
    @name = name
    @color = color
  end

  def start_prompt
    puts "#{@name}, select a piece:"
    sleep(0.4)
  end

  def end_prompt
    puts "Select your end position:"
    sleep(0.4)
  end
end
