# typed: true

require 'sorbet-runtime'

class Player
  extend T::Sig

  attr_reader :name, :piece

  # Initialize a player with representing name, piece of choice - black or white
  # and inject a game board where the player can put piece on
  # @param [String] name The name of player, eg John Doe
  # @param [Symbol] piece The piece a player choose either :B or :W
  # @param [Board] board An instance of the Board class, where players play on
  sig do
    params(
      name: String,
      piece: Symbol,
      board: Board
    ).void
  end
  def initialize(name, piece, board)
    # see https://sorbet.org/docs/error-reference#7006 for T.unsafe
    raise "Piece must be a symbol" unless T.unsafe(piece.is_a?(Symbol))
    @name = name
    @piece = piece
    @board = board
  end

  # keep asking for user input until a valid coordinates is received and the
  # piece is added to the coordinates
  def request_add_piece
    while true
      coordinates = get_player_input

      if valid_coordinates?(coordinates)
        if @board.add_piece(coordinates, @piece)
          break
        end
      end
    end
  end

  private

    # @return [Array<Integer>] An array of 2 integers representing coordinates
    # element at index 0 represents row, element at index 1 represents col
    sig { returns(T::Array[Integer]) }
    def get_player_input
      puts "Please enter your coordinates in the format and order of (row, colum):"
      gets.split(",").map(&:to_i)
    end

    # @param [Array<Integer>] coordinates The array of only row and col index
    # @return [Boolean] Return true if coordinates is valid otherwise false
    sig { params(coordinates: T::Array[Integer]).returns(T::Boolean) }
    def valid_coordinates?(coordinates)
      # with sorbet typechecking first condition check is NOT necessary
      if (coordinates.is_a?(Array) && coordinates.length == 2)
        true
      else
        puts "Please re-enter you coordinates in a valid format"
        false
      end
    end
end
