require 'ostruct'

module TournamentSystem
  module Algorithm
    # This module provides algorithms for dealing with double bracket elimination tournaments.
    module DoubleBracket
      extend self

      # Get the number of rounds required for a double bracket tournament.
      #
      # @param teams_count [Number]
      # @return [Number]
      def total_rounds(teams_count)
        Math.log2(teams_count).ceil * 2
      end

      # Get the maximum number of teams that can be processed in the given number of rounds.
      #
      # @param rounds [Number]
      # @return [Number]
      def max_teams(rounds)
        2**(rounds / 2)
      end

      # Guess the next round number given the number of teams and matches played so far.
      # Due to the complexity of double elimination, this practically runs through the tournament one round at a time,
      # but is still faster as it only handles numbers and not concrete teams.
      #
      # @param teams_count [Number]
      # @param matches_count [Number]
      # @return [Number]
      # @raise [ArgumentError] when the number of matches does not add up
      def guess_round(teams_count, matches_count)
        counting_state = OpenStruct.new(winners: teams_count, losers: 0)

        round_number = count_iterations do |round|
          round_size = count_round(round, counting_state)

          next false if round_size > matches_count || round_size.zero?

          matches_count -= round_size
        end

        raise ArgumentError, "Invalid number of matches, was off by #{matches_count}" unless matches_count.zero?

        round_number
      end

      # Determines whether a given round is a minor round, ie. the top and bottom bracket have a round.
      # Use this in combination with {#major_round?} to determine the type of round.
      # The first round is neither minor nor major.
      #
      # @param round [Number]
      # @return [Boolean]
      def minor_round?(round)
        round.odd?
      end

      # Determines whether a given round is a major round, ie. only the bottom bracket has a round.
      # Use this in combination with {#minor_round?} to determine the type of round.
      # The first round is neither major nor minor.
      #
      # @param round [Number]
      # @return [Boolean]
      def major_round?(round)
        round.even? && round.positive?
      end

      # Seed the given teams for a double bracket tournament. Identical to {SingleBracket#seed}.
      #
      # @param teams [Array<team>]
      # @return [Array<team>]
      def seed(teams)
        SingleBracket.seed(teams)
      end

      private

      # Handle state transition for a round. Counts the number of winners and losers.
      #
      # @return [Number] the number of matches played this round.
      def count_round(round, state)
        if minor_round? round
          count_minor_round(state)
        elsif major_round? round
          count_major_round(state)
        else
          count_first_round(state)
        end
      end

      # @return [Number] the number of matches played this round.
      def count_minor_round(state)
        winner_matches = state.winners / 2
        state.winners -= winner_matches

        loser_matches = state.losers / 2
        state.losers += winner_matches - loser_matches

        winner_matches + loser_matches
      end

      # @return [Number] the number of matches played this round.
      def count_major_round(state)
        matches = state.losers / 2
        state.losers -= matches
        matches
      end

      # @return [Number] the number of matches played this round.
      def count_first_round(state)
        winners = state.winners
        padded_teams = Util.padded_teams_pow2_count(winners)

        matches = winners - padded_teams / 2
        state.winners -= matches
        state.losers += matches
        matches
      end

      # Count the number of iterations until the block returns false.
      def count_iterations
        counter = 0
        counter += 1 while (yield counter) != false
        counter
      end
    end
  end
end
