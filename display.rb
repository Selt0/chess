require 'colorize'
require_relative 'board'
require_relative 'cursor'

class Display
  def initialize(board)
    @board = board
    @cursor = Cursor.new([0,0], board)
  end
end