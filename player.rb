class Player
  attr_reader :color, :display

  def initialize(color, display)
    @color = color
    @display = display
  end

  def player_disp
    @color == :white ? 'player1' : 'player2'
  end
end