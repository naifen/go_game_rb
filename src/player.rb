class Player
  # Initialize a player with representing name, piece of choice - black or white
  # and inject a game board where the player can put piece on
  # @param [String] name The name of player, eg John Doe
  # @param [Symbol] piece The piece a player choose either :B or :W
  # @param [Board] board An instance of the Board class, where players play on
  def initialize(name, piece, board)
    raise "Piece must be a symbol" unless piece.is_a? Symbol
    @name = name
    @piece = piece
    @board = board
  end
end
