module TournamentSystem
  module Algorithm
    # This module provides algorithms for dealing with the page playoff system.
    module PagePlayoff
      extend self

      # The total number of rounds needed for all page playoff tournaments.
      TOTAL_ROUNDS = 3

      # Mapping from number of matches to round number
      MATCH_ROUND_MAP = {
        0 => 0,
        2 => 1,
        3 => 2,
      }.freeze
      private_constant :MATCH_ROUND_MAP

      # :reek:ControlParameter

      # Guess the next round (starting at 0) for page playoff.
      #
      # @param matches_count [Integer] the number of existing matches
      # @return [Integer]
      # @raise [ArgumentError] when the number of matches doesn't add up
      def guess_round(matches_count)
        round = MATCH_ROUND_MAP[matches_count]

        raise ArgumentError, 'Invalid number of matches' unless round

        round
      end
    end
  end
end
