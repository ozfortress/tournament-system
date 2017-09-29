module Tournament
  module Algorithm
    # This module provides group pairing algorithms
    module GroupPairing
      extend self

      # Adjacent pairing (aka. King Of The Hill pairing)
      #
      # Pair adjacent teams.
      #
      # @example
      #   adjacent([1, 2, 3, 4]) #=> [[1, 2], [3, 4]]
      #
      # @param teams [Array<team>]
      # @return [Array<Array(team, team)>]
      def adjacent(teams)
        teams.each_slice(2).to_a
      end

      # Fold pairing (aka. Slaughter pairing)
      #
      # Pair the top team with the bottom team
      #
      # @example
      #   fold([1, 2, 3, 4]) #=> [[1, 4], [2, 3]]
      #
      # @param teams [Array<team>]
      # @return [Array<Array(team, team)>]
      def fold(teams)
        top, bottom = teams.each_slice(teams.length / 2).to_a

        bottom.reverse!

        top.zip(bottom).to_a
      end

      # Slide pairing (aka cross pairing).
      #
      # Pair the top half of teams with the bottom half, respectively.
      #
      # @example
      #   pair([1, 2, 3, 4]) #=> [[1, 3], [2, 4]]
      #
      # @param teams [Array<team>]
      # @return [Array<Array(team, team)>]
      def slide(teams)
        top, bottom = teams.each_slice(teams.length / 2).to_a

        top.zip(bottom).to_a
      end

      # Random pairing
      #
      # Pair teams randomly.
      #
      # @example
      #   pair([1, 2, 3, 4, 5, 6]) #=> [[1, 4], [2, 6], [3, 5]]
      #
      # @param teams [Array<team>]
      # @return [Array<Array(team, team)>]
      def random(teams)
        adjacent(teams.shuffle)
      end
    end
  end
end
