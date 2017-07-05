require 'tournament/algorithm/util'
require 'tournament/algorithm/pairers/halves'

module Tournament
  module Algorithm
    # This module provides algorithms for dealing with round robin tournament
    # systems.
    module RoundRobin
      extend self

      # Calculates the total number of rounds needed for round robin with a
      # certain amount of teams.
      #
      # @param teams_count [Integer] the number of teams
      # @return [Integer] number of rounds needed for round robin
      def total_rounds(teams_count)
        Util.padded_teams_count(teams_count) - 1
      end

      # Guess the next round (starting at 0) for round robin.
      #
      # @param teams_count [Integer] the number of teams
      # @param matches_count [Integer] the number of existing matches
      # @return [Integer] next round number
      def guess_round(teams_count, matches_count)
        matches_count / (Util.padded_teams_count(teams_count) / 2)
      end

      # Rotate array using round robin.
      #
      # @param array [Array<>] array to rotate
      # @param round [Integer] the round number, ie. amount to rotate by
      def round_robin(array, round)
        rotateable = array[1..-1]

        [array[0]] + rotateable.rotate(-round)
      end

      # Enumerate all round robin rotations.
      def round_robin_enum(array)
        Array.new(total_rounds(array.length)) do |index|
          round_robin(array, index)
        end
      end

      # Rotates teams and pairs them for a round of round robin.
      #
      # Uses {Pairers::Halves} for pairing after rotating.
      #
      # @param teams [Array<team>] teams playing
      # @param round [Integer] the round number
      # @return [Array<Array(team, team)>] the paired teams
      def round_robin_pairing(teams, round)
        rotated = round_robin(teams, round)

        Pairers::Halves.pair(rotated, bottom_reversed: true)
      end
    end
  end
end
