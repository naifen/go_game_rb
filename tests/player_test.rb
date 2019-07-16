# typed: false
require 'test/unit'
require_relative "../src/player"
require_relative "../src/board"

class PlayerTest < Test::Unit::TestCase
  def test_valid_coordinates
    board = Board.new
    player_w = Player.new("White", :W, board)
    assert_equal true, player_w.send(:valid_coordinates?, [1, 2]),
                 "Expect return true with a valid coordinates"
    assert_equal false, player_w.send(:valid_coordinates?, [1, 2, 3]),
                "Expect return false if the coordinates' length is NOT 2"
    assert_equal false, player_w.send(:valid_coordinates?, [1]),
                "Expect return false if the coordinates' length is NOT 2"
  end
end
