# typed: true

require 'sorbet-runtime'

class Board
  extend T::Sig

  attr_reader :board

  # @param [Integer] size The size of the square board
  # initialize a square board with given size, a 2-dimentional Array<Symbol>
  # default to 10x10 board
  sig { params(size: Integer).void }
  def initialize(size: 10)
    @board = Array.new(size) { Array.new(size) }
    @marked_locations = create_marked_board(size)
    @eat_count = 0
  end

  # print the board with colum indicator on top and row indicator to the left
  # if a cell is nil, print "+" char, othewise print the Symbol :B or :W
  def render
    puts

    # 1st line col num
    @board.each_with_index do |row, i|
      i == 0 ? print("   #{i} ") : i > 9 ? print("#{i}") : print("#{i} ")
    end

    puts

    @board.each_with_index do |row, i|
      i < 10 ? print("#{i}  ") : print("#{i} ")# row index
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
  sig do
    params(
      coordinates: T::Array[Integer],
      piece: Symbol
    ).returns(T::Boolean)
  end
  def add_piece(coordinates, piece)
    if can_add_to?(coordinates)
      @board[coordinates[0]][coordinates[1]] = piece
      true
    else
      false
    end
  end
  # TODO: implement revert last added piece
  # def revert_last_add; end

  # TODO: implement find winner
  sig { params(piece: Symbol).returns(T::Boolean) }
  def winner_is?(piece)
    false
  end

  # How to check for CHI after a player placed a piece:
  # 1, check if this piece casuing self lose piece -> invalid placement if ture
  # 2, check if this piece casuing opponent lose piece(piece is eaten)
  # How to check if a piece can be eaten:
  # 1, check its adjecent [left, up, right, down] locations has chi?
  # 2, if no chi(surround by other type, or board), eat it
  # 3, if any of the direction has a same color piece, recursively check chi.
  # TODO: def update_board

  private

    # @param [Integer] row_index The index of row of the location to check
    # @param [Integer] col_index The index of column of the location to check
    # @param [Symbol] piece The symbol :W or :B representing piece(white or black)
    # @return [Boolean] Return true if CHI is found, otherwise false
    sig do
      params(
        row_index: Integer,
        col_index: Integer,
        piece: Symbol
      ).returns(T::Boolean)
    end
    def has_chi?(row_index, col_index, piece)
      return true if @board[row_index][col_index].nil? # found chi, exit recursion
      return false if @board[row_index][col_index] != piece # NO chi

      @eat_count += 1
      @marked_locations[row_index][col_index] = true # mark every checked location

      if    row_index > 0 &&
            !@marked_locations[row_index - 1][col_index] &&
            has_chi?(row_index - 1, col_index, piece)
        true
      elsif row_index < (@board.length - 1) &&
            !@marked_locations[row_index + 1][col_index] &&
            has_chi?(row_index + 1, col_index, piece)
        true
      elsif col_index > 0 &&
            !@marked_locations[row_index][col_index - 1] &&
            has_chi?(row_index, col_index - 1, piece)
        true
      elsif col_index < (@board.length - 1) &&
            !@marked_locations[row_index][col_index + 1] &&
            has_chi?(row_index, col_index + 1, piece)
        true
      else
        false
      end
    end

    # Eat the piece at give coordinates, and its connected piece with SAME color
    # @param [Integer] row_index The index of row of the first piece to eat
    # @param [Integer] col_index The index of column of the first piece to eat
    # @param [Symbol] piece The symbol :W or :B representing piece(white or black)
    sig do
      params(
        row_index: Integer,
        col_index: Integer,
        piece: Symbol
      ).void
    end
    def eat_piece(row_index, col_index, piece)
      return if @board[row_index][col_index] != piece # found the other color, exit

      @board[row_index][col_index] = nil

      eat_piece(row_index - 1, col_index, piece) if row_index > 0
      eat_piece(row_index + 1, col_index, piece) if row_index < @board.length - 1
      eat_piece(row_index, col_index - 1, piece) if col_index > 0
      eat_piece(row_index, col_index + 1, piece) if col_index < @board.length - 1
    end

    # @param [Array<Integer>] coordinates The coordinates to add piece on board
    # @return [Boolean] return true if a piece can be added to the given coordinates
    # on board, otherwise return false
    sig { params(coordinates: T::Array[Integer]).returns(T::Boolean) }
    def can_add_to?(coordinates)
      valid_coordinates?(coordinates) && coordinates_available?(coordinates)
    end

    # @param [Array<Integer>] coordinates The coordinates to add piece on board
    # @return [Boolean] Return true if given coordinates exists on board, return
    # false otherwise
    sig { params(coordinates: T::Array[Integer]).returns(T::Boolean) }
    def valid_coordinates?(coordinates)
      if (0..@board.length - 1).include?(coordinates[0]) &&
         (0..@board.length - 1).include?(coordinates[1])
        true
      else
        puts "Coordinates must within the range of the board."
        false
      end
    end

    # @param [Array<Integer>] coordinates The coordinates to add piece on board
    # @return [Boolean] Return true if given coordinates is still available on
    # board, return false otherwise
    sig { params(coordinates: T::Array[Integer]).returns(T::Boolean) }
    def coordinates_available?(coordinates)
      if @board[coordinates[0]][coordinates[1]].nil?
        true
      else
        puts "This spot is already taken, please try another one."
        false
      end
    end

    # @return [Array<Array[Boolean]> Return a 2d array of booleans, the same size
    # as @board. Use it to mark checked locations on the board
    sig { params(size: Integer).returns(T::Array[T::Array[T::Boolean]]) }
    def create_marked_board(size)
      Array.new(size) { Array.new(size, false) }
    end
end
