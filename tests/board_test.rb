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
"  0 1 2 3 4 5 6 7 8 9 \n" +
"0 + + + + + + + + + + \n" +
"1 + + + + + + + + + + \n" +
"2 + + + + + + + + + + \n" +
"3 + + + + + + + + + + \n" +
"4 + + + + + + + + + + \n" +
"5 + + + + + + + + + + \n" +
"6 + + + + + + + + + + \n" +
"7 + + + + + + + + + + \n" +
"8 + + + + + + + + + + \n" +
"9 + + + + + + + + + + \n" +
"\n"
  BOARD6X6 = "\n" +
"  0 1 2 3 4 5 \n" +
"0 + + + + + + \n" +
"1 + + + + + + \n" +
"2 + + + + + + \n" +
"3 + + + + + + \n" +
"4 + + + + + + \n" +
"5 + + + + + + \n" +
"\n"

  def test_render
    @b.render
    assert_equal BOARD10X10,  $stdout.string
  end

  def test_render_with_specific_board_size
    b6x6 = Board.new(size: 6)
    b6x6.render
    assert_equal BOARD6X6,  $stdout.string
  end

  def test_add_piece
    is_added = @b.add_piece([3, 5], :B)
    assert_equal :B, @b.board[3][5]
    assert_equal true, is_added,
                 "Expect a piece can be add if in range and coordinates is empty"

    # is_not_added = @b.add_piece([10000, 10000], :W)
    # assert_equal false, is_not_added,
                 # "Expect a piece can NOT be add if a coordinate in NOT range"
  end
end
