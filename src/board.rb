class Board
  attr_reader :board

  # @param [Integer] size The size of the square board
  # initialize a square board with given size, a 2-dimentional Array<Symbol>
  # default to 10x10 board
  def initialize(size: 10)
    @board = Array.new(size) { Array.new(size) }
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
  def add_piece(coordinates, piece)
    if can_add_to?(coordinates)
      @board[coordinates[0]][coordinates[1]] = piece
      true
    else
      false
    end
  end
  # TODO: implement to revert one turn

  # @param [Array<Integer>] coordinates The coordinates to add piece on board
  # @return [Boolean] return true if a piece can be added to the given coordinates
  # on board, otherwise return false
  def can_add_to?(coordinates)
    valid_coordinates?(coordinates) && coordinates_available?(coordinates)
  end

  # TODO: implement find winner
  def winner_is?(piece)
    false
  end

  private

    # @param [Array<Integer>] coordinates The coordinates to add piece on board
    # @return [Boolean] Return true if given coordinates exists on board, return
    # false otherwise
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
    def coordinates_available?(coordinates)
      if @board[coordinates[0]][coordinates[1]].nil?
        true
      else
        puts "This spot is already taken, please try another one."
        false
      end
    end
end
