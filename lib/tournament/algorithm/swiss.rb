module Tournament
  module Algorithm
    # This module provides algorithms for dealing with swiss tournament systems. Specifically it provides algorithms for
    # grouping teams.
    module Swiss
      extend self

      # Calculates the minimum number of rounds needed to properly order teams using the swiss tournament system.
      #
      # @param teams_count [Integer] the number of teams
      # @return [Integer]
      def minimum_rounds(teams_count)
        Math.log2(teams_count).ceil
      end

      # Groups teams by their score.
      #
      # @param teams [Array<team>] the teams to group
      # @param scores [Hash{team => Number}] the scores of each team
      # @return [Array<Array<team>>] groups of teams sorted
      #                              with the highest score at the front
      def group_teams_by_score(teams, scores)
        groups = teams.group_by { |team| scores[team] || 0 }
        sorted_keys = groups.keys.sort.reverse

        sorted_keys.map { |key| groups[key] }
      end

      # Rollover the last person in each group if its odd.
      # This assumes that the total number of players in all groups is even.
      # Rollover is performed in-place.
      #
      # @param groups [Array<Array<team>>] groups of teams
      # @return [nil]
      def rollover_groups(groups)
        groups.each_with_index do |group, index|
          # Move last from the current group to the front of the next group
          groups[index + 1].unshift group.pop if group.length.odd?
        end

        # Remove any empty groups
        groups.reject!(&:empty?)

        nil
      end
    end
  end
end
