class Game
  # Initialize the game with a board and two players, black piece go first
  # @param [Board] board An instance of Board class
  # @param [Player] @player_b The instances of Player class with black piece
  # @param [Player] @player_w The instances of Player class with white piece
  def initialize(board, player_b, player_w)
    @board = board
    @player_b = player_b
    @player_w = player_w
    @current_player = @player_b
  end
end
