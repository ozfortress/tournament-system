module Tournament
  module Algorithm
    # This module provides algorithms for dealing with swiss tournament systems.
    # Specifically it provides algorithms for grouping teams.
    #
    # @see Pairers Pairers for possible use with swiss.
    module Swiss
      extend self

      # Calculates the minimum number of rounds needed to properly order teams
      # using the swiss tournament system.
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

      # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      # :reek:DuplicateMethodCall

      # Merge small groups to the right (if possible) such that all groups
      # are larger than min_size.
      # Merging is performed in-place.
      #
      # @param groups [Array<Array<team>>] groups of teams
      # @param min_size [Integer] the minimum size of groups
      # @return [void]
      def merge_small_groups(groups, min_size)
        # Iterate all groups up until the last
        index = 0
        while index < groups.length - 1
          # Merge group to the right until this group is large enough
          while groups[index].length < min_size && index + 1 < groups.length
            groups[index] += groups.delete_at(index + 1)
          end

          index += 1
        end

        # Merge the last group to the left if its too small
        if groups[-1].length < min_size && groups.length != 1
          last = groups.delete_at(-1)
          groups[-1] += last
        end

        nil
      end
      # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

      # Rollover the last person in each group if its odd.
      # This assumes that the total number of players in all groups is even.
      # Rollover is performed in-place.
      #
      # @param groups [Array<Array<team>>] groups of teams
      # @return [void]
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
