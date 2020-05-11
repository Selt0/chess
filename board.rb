require_relative 'pieces'

class Board
  attr_reader :grid

  def initialize(fill_board = true)
    @sentinel = NullPiece.instance
    make_starting_grid(fill_board)
  end

  def [](pos)
    raise 'invalid pos' unless valid_pos?(pos)
    x, y = pos
    grid[x][y]
  end

  def []=(pos, piece)
    raise 'invalid pos' unless valid_pos?(pos)
    x, y = pos
    grid[x][y] = piece
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

  def move_piece(turn_color, start_pos, end_pos)
    raise "That position is empty" if empty?(start_pos)

    piece = self[start_pos]
    if piece.color != turn_color
      raise "That is not your piece!"
    elsif !piece.moves.include?(end_pos)
      raise "That piece cannot move like that"
    elsif !piece.valid_moves.include?(end_pos)
      raise "You cannot move there"
    end

    move_piece!(start_pos, end_pos)
  end

  #move without checks
  def move_piece!(start_pos, end_pos)
    piece = self[start_pos]

    self[end_pos] = piece
    self[start_pos] = sentinel
    piece.pos = end_pos

    nil
  end

  def in_check?(color)
    king_pos = find_king(color).pos
    pieces.any? do |p|
      p.color != color && p.moves.include?(king_pos)
    end
  end

  def checkmate?(color)
    return false unless in_check(color)

    pieces.select { |p| p.color == color }.all? do |piece|
      piece.valid_moves.empty?
    end
  end
  
  private

  attr_reader :sentinel

  def make_starting_grid(fill_board)
    @grid = Array.new(8) { Array.new(8, sentinel) }
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

  def find_king(color)
    king_pos = pieces.find { |p| p.color == color && p.is_a?(King) }
    king_pos || (raise "king not found?")
  end
end