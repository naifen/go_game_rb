require 'test/unit'
require_relative "../src/player"
require_relative "../src/board"
require_relative "../src/game"

class GameTest < Test::Unit::TestCase
  def test_switch_players
    board = Board.new
    player_b = Player.new("Black", :B, board)
    player_w = Player.new("White", :W, board)
    game = Game.new(board, player_b, player_w)
    game.send(:switch_players)
    # black piece player go 1st, after 1st switch current player is white piece
    assert_equal player_w, game.instance_variable_get(:@current_player),
                 "Expect default board row count to be"
  end
end
