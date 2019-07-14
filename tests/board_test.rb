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
    assert_equal true, is_added,
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
end
