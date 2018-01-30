require 'ostruct'

module TournamentSystem
  module Algorithm
    # This module provides algorithms for dealing with single bracket
    # elimination tournament systems.
    module SingleBracket
      extend self

      # Calculates the total number of rounds needed for a single bracket
      # tournament with a certain number of teams.
      #
      # @param teams_count [Integer] the number of teams
      # @return [Integer] number of rounds needed for round robin
      def total_rounds(teams_count)
        Math.log2(teams_count).ceil
      end

      # Calculates the maximum number of teams that can play in a single bracket
      # tournament with a given number of rounds.
      #
      # @param rounds [Integer] the number of rounds
      # @return [Integer] number of teams that could play
      def max_teams(rounds)
        2**rounds
      end

      # Guess the next round (starting at 0) for a single bracket tournament.
      #
      # @param teams_count [Integer] the number of teams
      # @param matches_count [Integer] the number of existing matches
      # @return [Integer] next round number
      # @raise [ArgumentError] when the number of matches does not add up
      def guess_round(teams_count, matches_count)
        rounds = total_rounds(teams_count)
        total_teams = max_teams(rounds)

        # Make sure we don't have too many matches
        raise ArgumentError, 'Too many matches' unless total_teams >= matches_count

        round = rounds - Math.log2(total_teams - matches_count)
        # Make sure we don't have some weird number of matches
        raise ArgumentError, 'Invalid number of matches' unless (round % 1).zero?

        round.to_i
      end

      # Padd an array of teams to the next highest power of 2.
      #
      # @param teams [Array<team>]
      # @return [Array<team, nil>]
      def padd_teams(teams)
        required = max_teams(total_rounds(teams.length))

        # Insert the padding at the bottom to give top teams byes first
        Array.new(required) { |index| teams[index] }
      end

      # Seed teams for a single bracket tournament.
      #
      # Seed in a way that teams earlier in +teams+ always win against later
      # ones, the first team plays the second in the finals, the 3rd and 4th get
      # nocked out in the semi-finals, etc.
      #
      # Designed to be used with {GroupPairing#adjacent}.
      #
      # @param teams [Array<Team>]
      # @return [Array<team>]
      # @raise [ArgumentError] when the number of teams is not a power of 2
      def seed(teams)
        raise ArgumentError, 'Need power-of-2 teams' unless (Math.log2(teams.length) % 1).zero?

        teams = teams.map.with_index do |team, index|
          OpenStruct.new(team: team, index: index)
        end
        seed_bracket(teams).map(&:team)
      end

      private

      # Recursively seed the top half of the teams and match teams reversed by
      # index to the bottom half.
      def seed_bracket(teams)
        return teams if teams.length <= 2

        top_half, bottom_half = teams.each_slice(teams.length / 2).to_a
        top_half = seed_bracket top_half

        top_half.map do |team|
          # match with the team appropriate team in the bottom half
          match = bottom_half[-team.index - 1]

          [team, match]
        end.flatten
      end
    end
  end
end
