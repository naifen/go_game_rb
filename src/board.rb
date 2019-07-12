class Board
  attr_reader :board

  # @param [Integer] size The size of the square board
  # initialize a square board with given size, a 2-dimentional Array<Symbol>
  # default to 10x10 board
  def initialize(size: 10)
    @board = Array.new(size) { Array.new(size) }
  end

  # TODO: render correctly for index is 2 digits
  # print the board with colum indicator on top and row indicator to the left
  # if a cell is nil, print "+" char, othewise print the Symbol :B or :W
  def render
    puts
    # 1st line col num
    @board.each_with_index do |row, i|
      i == 0 ? print("  #{i} ") : print("#{i} ")
    end
    puts
    @board.each_with_index do |row, i|
      print "#{i} " # row num
      row.each do |cell|
        cell.nil? ? print("+") : print(cell.to_s)
        print(" ")
      end
      puts
    end
    puts
  end

  # @example add_piece([5, 6], :B) Add piece :B to row 5 col 6
  # @param [Array<Integer>] coordinates The coordinates to add piece on board
  # @param [Symbol] piece The piece to be added either :B or :W
  # @return [Boolean] return true if piece added, false if piece not added
  def add_piece(coordinates, piece)
    if can_add_to?(coordinates)
      @board[coordinates[0]][coordinates[1]] = piece
      true
    else
      false
    end
  end

  # @param [Array<Integer>] coordinates The coordinates to add piece on board
  # @return [Boolean] return true if a piece can be added to the given coordinates
  # on board, otherwise return false
  def can_add_to?(coordinates)
    # within_valid_coordinates?(coordinates) && is_coordinates_available?(coordinates)
    true
  end

  def winner_is?(piece)
    false
  end
end
