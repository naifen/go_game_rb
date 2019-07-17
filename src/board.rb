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
  # FIXME: does NOT always correctly eat a block of piece

  # @param [Integer] row_index The index of row of the first piece to eat
  # @param [Integer] col_index The index of column of the first piece to eat
  # @param [Symbol] piece The symbol :W or :B representing piece(white or black)
  sig do
    params(
      row_index: Integer,
      col_index: Integer,
      piece: Symbol
    ).returns(Integer)
  end
  def update_board_and_eat_count(row_index, col_index, piece)
    result = 0

    @marked_locations = create_marked_board(@board.length)
    self_has_chi = has_chi_at?(row_index, col_index, piece)
    @eat_count = 0
    location = [-1000, -1000] # array is passed by reference, which will be modified by other function call
    other_piece = (piece == :W ? :B : :W)
    @marked_locations = create_marked_board(@board.length)
    # check placement of i, j casue other color lost its chi
    # update the location to where otherColor has no Chi
    other_have_chi = all_have_chi?(other_piece, location)

    if !self_has_chi && other_have_chi
      @board[row_index][col_index] = nil
      puts "Suicide not allowed!" # TODO: does not switch user for this
      return 0
    end

    # start to recursively eat piece from location where otherColor has no Chi
    if !other_have_chi
      eat_piece(location[0], location[1], other_piece)

      if other_piece == 1
        result = @eat_count
      else
        result -= @eat_count
      end
    end

    result
  end

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
    def has_chi_at?(row_index, col_index, piece)
      return true if @board[row_index][col_index].nil? # found chi, exit recursion
      return false if @board[row_index][col_index] != piece # NO chi

      @eat_count += 1
      @marked_locations[row_index][col_index] = true # mark every checked location

      if    row_index > 0 &&
            !@marked_locations[row_index - 1][col_index] &&
            has_chi_at?(row_index - 1, col_index, piece)
        true
      elsif row_index < (@board.length - 1) &&
            !@marked_locations[row_index + 1][col_index] &&
            has_chi_at?(row_index + 1, col_index, piece)
        true
      elsif col_index > 0 &&
            !@marked_locations[row_index][col_index - 1] &&
            has_chi_at?(row_index, col_index - 1, piece)
        true
      elsif col_index < (@board.length - 1) &&
            !@marked_locations[row_index][col_index + 1] &&
            has_chi_at?(row_index, col_index + 1, piece)
        true
      else
        false
      end
    end

    # Check the entire board and determine if all piece of given color have chi,
    # pass in an array as argument torecord the location where no chi is found
    # Array in ruby is passed into method as reference so mutation to array in a
    # method will mutate the original array
    # @param [Symbol] piece The symbol :W or :B representing piece(white or black)
    # @parmm [Array<Integer>] no_chi_loc The location where given piece has no chi
    # @return [Boolean] Retrun whether all piece of given color have chi
    sig do
      params(
        piece: Symbol,
        no_chi_loc: T::Array[Integer],
      ).returns(T::Boolean)
    end
    def all_have_chi?(piece, no_chi_loc = [0, 0]) # array passed in as ref in ruby
      @board.each_with_index do |row, i|
        row.each_with_index do |cell, j|
          next if @board[i][j] != piece || @marked_locations[i][j]
          @eat_count = 0

          unless has_chi_at?(i, j, piece)
            no_chi_loc[0] = i
            no_chi_loc[1] = j
            return false
          end
        end
      end

      true
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
