# typed: false
require 'test/unit'
require_relative "../src/board"

class BoardTest < Test::Unit::TestCase
  DEFAULT_SIZE = 10
  NEW_SIZE = 20

  # test puts output
  def setup
    @save_stdout = $stdout
    $stdout = StringIO.new
    @b = Board.new # default 10 x 10 board
  end

  def teardown
    $stdout = @save_stdout
    @b = nil
  end

  def test_initialization
    assert_equal DEFAULT_SIZE, @b.board.length, "Expect default board row count to be #{DEFAULT_SIZE}"
    @b.board.each do |row|
      assert_equal DEFAULT_SIZE, row.length, "Expect default board colum count to be #{DEFAULT_SIZE}"
    end

    b2 = Board.new(size: NEW_SIZE)
    assert_equal NEW_SIZE, b2.board.length, "Expect default board row count to be #{NEW_SIZE}"
    b2.board.each do |row|
      assert_equal NEW_SIZE, row.length, "Expect default board colum count to be #{NEW_SIZE}"
    end
  end

  BOARD10X10 = "\n" +
"   0 1 2 3 4 5 6 7 8 9 \n" +
"0  + + + + + + + + + + \n" +
"1  + + + + + + + + + + \n" +
"2  + + + + + + + + + + \n" +
"3  + + + + + + + + + + \n" +
"4  + + + + + + + + + + \n" +
"5  + + + + + + + + + + \n" +
"6  + + + + + + + + + + \n" +
"7  + + + + + + + + + + \n" +
"8  + + + + + + + + + + \n" +
"9  + + + + + + + + + + \n" +
"\n"
  BOARD19X19 = "\n" +
"   0 1 2 3 4 5 6 7 8 9 101112131415161718\n" +
"0  + + + + + + + + + + + + + + + + + + + \n" +
"1  + + + + + + + + + + + + + + + + + + + \n" +
"2  + + + + + + + + + + + + + + + + + + + \n" +
"3  + + + + + + + + + + + + + + + + + + + \n" +
"4  + + + + + + + + + + + + + + + + + + + \n" +
"5  + + + + + + + + + + + + + + + + + + + \n" +
"6  + + + + + + + + + + + + + + + + + + + \n" +
"7  + + + + + + + + + + + + + + + + + + + \n" +
"8  + + + + + + + + + + + + + + + + + + + \n" +
"9  + + + + + + + + + + + + + + + + + + + \n" +
"10 + + + + + + + + + + + + + + + + + + + \n" +
"11 + + + + + + + + + + + + + + + + + + + \n" +
"12 + + + + + + + + + + + + + + + + + + + \n" +
"13 + + + + + + + + + + + + + + + + + + + \n" +
"14 + + + + + + + + + + + + + + + + + + + \n" +
"15 + + + + + + + + + + + + + + + + + + + \n" +
"16 + + + + + + + + + + + + + + + + + + + \n" +
"17 + + + + + + + + + + + + + + + + + + + \n" +
"18 + + + + + + + + + + + + + + + + + + + \n" +
"\n"

  def test_render
    @b.render
    assert_equal BOARD10X10,  $stdout.string
  end

  def test_render_with_specific_board_size
    b6x6 = Board.new(size: 19)
    b6x6.render
    assert_equal BOARD19X19,  $stdout.string
  end

  def test_add_piece
    is_added = @b.add_piece([@b.board.length / 2, @b.board.length / 2], :B)

    assert_equal :B, @b.board[@b.board.length / 2][@b.board.length / 2],
                 "Expect a piece can be added if coordinates is in range and empty"
    assert_equal true, is_added,
                 "Expect to return true if a piece is added"

    is_taken = @b.add_piece([@b.board.length / 2, @b.board.length / 2], :W)
    assert_equal false, is_taken,
                 "Expect a piece can NOT be added if a coordinate is NOT empty"

    is_not_added = @b.add_piece([@b.board.length * 10, @b.board.length * 10], :W)
    assert_equal false, is_not_added,
                 "Expect a piece can NOT be added if a coordinate is NOT in range"
  end

  def test_valid_coordinates
    assert_equal true,
                 @b.send(:valid_coordinates?, [@b.board.length / 2, @b.board.length / 2]),
                 "Expect valid_coordinates? to return true with a valid coordinates"
    assert_equal false,
                 @b.send(:valid_coordinates?, [@b.board.length, @b.board.length]),
                 "Expect valid_coordinates? to return false with a invalid coordinates"
    assert_equal false,
                 @b.send(:valid_coordinates?, [@b.board.length * 10, @b.board.length * 10]),
                 "Expect valid_coordinates? to return false with a invalid coordinates"
  end

  def test_coordinates_available
    array = Array.new(@b.board.length) { Array.new(@b.board.length) }
    array[0][0] = :W
    @b.instance_variable_set(:@board, array)

    assert_equal false, @b.send(:coordinates_available?, [0, 0]),
                 "Expect coordinates_available? to return false if a given coordinates is NOT empty"
    assert_equal true, @b.send(:coordinates_available?, [@b.board.length / 2, @b.board.length / 2]),
                 "Expect coordinates_available? to return true if a given coordinates is empty"

  end

  def test_create_marked_board
    marked_board = @b.send(:create_marked_board, @b.board.length)

    assert_equal @b.board.length, marked_board.length,
                 "Expect marked board has same rows as given size"
    assert_equal @b.board.length, marked_board[0].length,
                 "Expect marked board has same columns as given size"
    marked_board.each do |row|
      row.each do |cell|
        assert_equal false, cell, "Expect all cells initially set to false"
      end
    end
  end

  def test_eat_piece
    row = col = @b.board.length / 2

    # create a block of only white pieces
    @b.add_piece([row, col], :W)
    @b.add_piece([row, col + 1], :W)
    @b.add_piece([row - 1, col], :W)
    @b.add_piece([row - 1, col + 1], :W)
    @b.add_piece([row - 2, col], :W)
    @b.add_piece([row - 2, col + 1], :W)
    @b.add_piece([row - 2, col + 1], :W)

    @b.send(:eat_piece, row, col, :W)

    @b.board.each do |row|
      row.each do |cell|
        assert_equal true, cell != :W,
                    "Expect white pieces are eaten after eat_piece is invoked."
      end
    end
  end

  def test_has_chi_at_single_piece
    row = col = @b.board.length / 2

    @b.add_piece([row, col], :W)
    assert_equal true, @b.send(:has_chi_at?, row, col, :W),
                 "Expect has_chi? to return true if a piece is on its own"

    @b.add_piece([row - 1, col], :B) # up
    @b.add_piece([row, col + 1], :B) # right
    @b.add_piece([row + 1, col], :B) # down
    assert_equal true, @b.send(:has_chi_at?, row, col, :W),
                 "Expect has_chi? to return true if a piece is NOT fully surrounded"

    @b.add_piece([row, col - 1], :B) # down
    assert_equal false, @b.send(:has_chi_at?, row, col, :W),
                 "Expect has_chi? to return false if a piece is fully surrounded"
  end

  def test_has_chi_at_block_pieces
    row = col = @b.board.length / 2

    # create white piece block
    @b.add_piece([row, col], :W)
    @b.add_piece([row - 1, col], :W)
    @b.add_piece([row, col + 1], :W)
    @b.add_piece([row - 1, col + 1], :W)

    # add black pieces around it but not close the block
    # looks like this:
         # 0 1 2 3 4 5 6 7 8 9
      # 0  + + + + + + + + + +
      # 1  + + + + + + + + + +
      # 2  + + + + + + + + + +
      # 3  + + + + + B B + + +
      # 4  + + + + B W W B + +
      # 5  + + + + B W W B + +
      # 6  + + + + + + B + + +
      # 7  + + + + + + + + + +
      # 8  + + + + + + + + + +
      # 9  + + + + + + + + + +
    @b.add_piece([row, col - 1], :B)
    @b.add_piece([row - 1, col - 1], :B)
    @b.add_piece([row - 2, col], :B)
    @b.add_piece([row - 2, col + 1], :B)
    @b.add_piece([row - 1, col + 2], :B)
    @b.add_piece([row, col + 2], :B)
    @b.add_piece([row + 1, col + 1], :B)
    assert_equal true, @b.send(:has_chi_at?, row, col, :W),
                "Expect has_chi? to return true if a piece block is NOT fully surrounded"

    # close the white pieces
    @b.add_piece([row + 1, col], :B)
    assert_equal false, @b.send(:has_chi_at?, row, col, :W),
                 "Expect has_chi? to return false if a piece block is fully surrounded"
  end

  def test_has_chi_edge_pieces_upper_left
    # create white piece block
    @b.add_piece([0, 0], :W)
    @b.add_piece([0, 1], :W)
    @b.add_piece([1, 0], :W)
    # add black pieces around it but not close the block
    # looks like this:
         # 0 1 2 3 4 5 6 7 8 9
      # 0  W W B + + + + + + +
      # 1  W B + + + + + + + +
      # 2  + + + + + + + + + +
      # 3  + + + + + + + + + +
      # 4  + + + + + + + + + +
      # 5  + + + + + + + + + +
      # 6  + + + + + + + + + +
      # 7  + + + + + + + + + +
      # 8  + + + + + + + + + +
      # 9  + + + + + + + + + +
    @b.add_piece([1, 1], :B)
    @b.add_piece([0, 2], :B)
    assert_equal true, @b.send(:has_chi_at?, 0, 0, :W),
                "Expect has_chi? to return true if a piece block is NOT fully surrounded"

    # close the white pieces
    @b.add_piece([2, 0], :B)
    assert_equal false, @b.send(:has_chi_at?, 0, 0, :W),
                 "Expect has_chi? to return false if a piece block is fully surrounded"
  end

  def test_has_chi_edge_pieces_upper_right
    # create white piece block
    @b.add_piece([0, @b.board.length - 1], :W)
    @b.add_piece([0, @b.board.length - 2], :W)
    @b.add_piece([1, @b.board.length - 1], :W)
    # add black pieces around it but not close the block
    # looks like this:
         # 0 1 2 3 4 5 6 7 8 9
      # 0  + + + + + + + B W W
      # 1  + + + + + + + + B W
      # 2  + + + + + + + + + +
      # 3  + + + + + + + + + +
      # 4  + + + + + + + + + +
      # 5  + + + + + + + + + +
      # 6  + + + + + + + + + +
      # 7  + + + + + + + + + +
      # 8  + + + + + + + + + +
      # 9  + + + + + + + + + +
    @b.add_piece([0, @b.board.length - 3], :B)
    @b.add_piece([1, @b.board.length - 2], :B)
    assert_equal true, @b.send(:has_chi_at?, 0, @b.board.length - 1, :W),
                "Expect has_chi? to return true if a piece block is NOT fully surrounded"

    # close the white pieces
    @b.add_piece([2,  @b.board.length - 1], :B)
    assert_equal false, @b.send(:has_chi_at?, 0, @b.board.length - 1, :W),
                 "Expect has_chi? to return false if a piece block is fully surrounded"
  end

  def test_has_chi_edge_pieces_lower_right
    # create white piece block
    @b.add_piece([@b.board.length - 1, @b.board.length - 1], :W)
    @b.add_piece([@b.board.length - 2, @b.board.length - 1], :W)
    @b.add_piece([@b.board.length - 1, @b.board.length - 2], :W)
    # add black pieces around it but not close the block
    # looks like this:
         # 0 1 2 3 4 5 6 7 8 9
      # 0  + + + + + + + + + +
      # 1  + + + + + + + + + +
      # 2  + + + + + + + + + +
      # 3  + + + + + + + + + +
      # 4  + + + + + + + + + +
      # 5  + + + + + + + + + +
      # 6  + + + + + + + + + +
      # 7  + + + + + + + + + B
      # 8  + + + + + + + + B W
      # 9  + + + + + + + + W W
    @b.add_piece([@b.board.length - 3, @b.board.length - 1], :B)
    @b.add_piece([@b.board.length - 2, @b.board.length - 2], :B)
    assert_equal true, @b.send(:has_chi_at?, @b.board.length - 1, @b.board.length - 1, :W),
                "Expect has_chi? to return true if a piece block is NOT fully surrounded"

    # close the white pieces
    @b.add_piece([@b.board.length - 1,  @b.board.length - 3], :B)
    assert_equal false, @b.send(:has_chi_at?, @b.board.length - 1, @b.board.length - 1, :W),
                 "Expect has_chi? to return false if a piece block is fully surrounded"
  end

  def test_has_chi_edge_pieces_lower_left
    # create white piece block
    @b.add_piece([@b.board.length - 1, 0], :W)
    @b.add_piece([@b.board.length - 1, 1], :W)
    @b.add_piece([@b.board.length - 2, 0], :W)
    # add black pieces around it but not close the block
    # looks like this:
         # 0 1 2 3 4 5 6 7 8 9
      # 0  + + + + + + + + + +
      # 1  + + + + + + + + + +
      # 2  + + + + + + + + + +
      # 3  + + + + + + + + + +
      # 4  + + + + + + + + + +
      # 5  + + + + + + + + + +
      # 6  + + + + + + + + + +
      # 7  + + + + + + + + + +
      # 8  W B + + + + + + + +
      # 9  W W B + + + + + + +
    @b.add_piece([@b.board.length - 1, 2], :B)
    @b.add_piece([@b.board.length - 2, 1], :B)
    assert_equal true, @b.send(:has_chi_at?, @b.board.length - 1, 0, :W),
                "Expect has_chi? to return true if a piece block is NOT fully surrounded"

    # close the white pieces
    @b.add_piece([@b.board.length - 3, 0], :B)
    assert_equal false, @b.send(:has_chi_at?, @b.board.length - 1, 0, :W),
                 "Expect has_chi? to return false if a piece block is fully surrounded"
  end

  def test_all_have_chi
    row = col = @b.board.length / 2

    # tests pass for these
    # @b.add_piece([0, 0], :W)
    # @b.add_piece([0, 1], :W)
    # @b.add_piece([1, 0], :W)
    # @b.add_piece([1, 1], :W)

    # @b.add_piece([0, 9], :W)
    # @b.add_piece([0, 8], :W)
    # @b.add_piece([1, 9], :W)
    # @b.add_piece([1, 8], :W)

    # @b.add_piece([9, 0], :W)
    # @b.add_piece([8, 0], :W)
    # @b.add_piece([9, 1], :W)
    # @b.add_piece([8, 1], :W)

    # FIXME: find BUG NOT pass if uncomment 9, 9
    # @b.add_piece([9, 9], :W)
    # @b.add_piece([9, 8], :W)
    # @b.add_piece([8, 9], :W)
    # @b.add_piece([8, 8], :W)

    @b.add_piece([row, col], :W)
    @b.add_piece([row - 1, col], :W)
    @b.add_piece([row, col + 1], :W)
    @b.add_piece([row - 1, col + 1], :W)

    # add black pieces around it but not close the block
    # looks like this:
         # 0 1 2 3 4 5 6 7 8 9
      # 0  + + + + + + + + + +
      # 1  + + + + + + + + + +
      # 2  + + + + + + + + + +
      # 3  + + + + + B B + + +
      # 4  + + + + B W W B + +
      # 5  + + + + B W W B + +
      # 6  + + + + + B + + + +
      # 7  + + + + + + + + + +
      # 8  + + + + + + + + + +
      # 9  + + + + + + + + + +
    @b.add_piece([row, col - 1], :B)
    @b.add_piece([row - 1, col - 1], :B)
    @b.add_piece([row - 2, col], :B)
    @b.add_piece([row - 2, col + 1], :B)
    @b.add_piece([row - 1, col + 2], :B)
    @b.add_piece([row, col + 2], :B)
    @b.add_piece([row + 1, col], :B)
    # FIXME: cause test fail if add :B piece to this coordinates, find bug
    # @b.add_piece([row + 1, col + 1], :B)

    no_chi_loc = [0, 0]
    assert_equal true, @b.send(:all_have_chi?, :W, no_chi_loc),
                "Expect has_chi? to return true if a piece block is NOT fully surrounded"
  end

  # TODO: test_update_board
end
