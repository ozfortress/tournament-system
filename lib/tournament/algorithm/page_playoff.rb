module Tournament
  module Algorithm
    # This module provides algorithms for dealing with the page playoff system.
    module PagePlayoff
      extend self

      # The total number of rounds needed for all page playoff tournaments.
      TOTAL_ROUNDS = 3

      # :reek:ControlParameter

      # Guess the next round (starting at 0) for page playoff.
      #
      # @param matches_count [Integer] the number of existing matches
      # @return [Integer]
      # @raise [ArgumentError] when the number of matches doesn't add up
      def guess_round(matches_count)
        case matches_count
        when 0 then 0
        when 2 then 1
        when 3 then 2
        else
          raise ArgumentError, 'Invalid number of matches'
        end
      end
    end
  end
end
