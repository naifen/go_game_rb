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

  # game keeps running until find a winner, switch player every turn.
  def run
    while true
      @board.render
      puts "#{@current_player.name}'s turn:"
      @current_player.request_add_piece
      break if game_over?
      switch_players
    end
  end

  private

    def game_over?
      won_game? #|| draw_game? # not sure how does GO game draw
    end

    # @return [Boolean] Return true if a winner presents, otherwise false
    def won_game?
      # check if a player's piece, either :W or :B, fulfills winning condition
      if @board.winner_is?(@current_player.piece)
        puts "Congratulations to the winner - #{@current_player.name}!"
        true
      else
        false
      end
    end

    def switch_players
      @current_player = @current_player == @player_b ? @player_w : @player_b
    end
end
