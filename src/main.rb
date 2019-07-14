# typed: strict
require_relative "board"
require_relative "player"
require_relative "game"

b = Board.new(size: 19)
# b.render
# b.add_piece([3, 6], :B)
# b.add_piece([5, 6], :W)
# b.render
# puts b.board[3][6].class
# puts b.board[6][6].class

pw = Player.new("White", :W, b)
pb = Player.new("Black", :B, b)
game = Game.new(b, pb, pw)
game.run
