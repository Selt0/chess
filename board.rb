require_relative 'pieces'

class Board
  attr_reader :board

  def initialize(fill_board = true)
    @sentinel = NullPiece.instance
    make_starting_grid(fill_board)
  end

  def [](pos)
    raise 'invalid pos' unless valid_pos?(pos)
    x, y = pos
    board[x][y]
  end

  def []=(pos, piece)
    raise 'invalid pos' unless valid_pos?(pos)
    x, y = pos
    board[x][y] = piece
  end
  
  def empty?(pos)
    self[pos].empty?
  end

  def valid_pos?(pos)
    pos.all?{ |coord| coord.between?(0, 7)}
  end

  def add_piece(piece, pos)
    raise "position not empty" unless empty?(pos)

    self[pos] = piece
  end

  private

  attr_reader :sentinel

  def make_starting_grid(fill_board)
    @board = Array.new(8) { Array.new(8, sentinel) }
    return unless fill_board
    %i(white black).each do |color|
      fill_back_row(color)
      fill_pawns_row(color)
    end
  end

  def fill_back_row(color)
    back_pieces = [
      Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook
    ]

    i = color == :white ? 7 : 0 
    back_pieces.each_with_index do |piece_class, j|
      piece_class.new(color, self, [i, j])
    end
  end

  def fill_pawns_row(color)
    i = color == :white ? 6 : 1
    8.times { |j| Pawn.new(color, self, [i, j]) }
  end
end