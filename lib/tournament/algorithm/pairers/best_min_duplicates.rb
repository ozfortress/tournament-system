require 'tournament/algorithm/util'

module Tournament
  module Algorithm
    module Pairers
      # Complex pairing system that tries to maximise uniqueness and
      # total score difference.
      module BestMinDuplicates
        extend self

        # Pair by minimising the number of duplicate matches,
        # then minimising the score difference.
        #
        # @see Util.all_perfect_matches
        #
        # @param teams [Array<team>] the teams to pair
        # @param scores [Hash{team => Numer}] a mapping from teams to scores
        # @param matches_counts [Hash{Set(team, team) => Integer}]
        #   A mapping from unique matches to their number of previous
        #   occurrences.
        def pair(teams, scores, matches_counts)
          # enumerate all unique pairings using round robin
          perfect_matches = Util.all_perfect_matches(teams, 2)

          # Find all possible pairings with minimum duplicates
          min_pairings = perfect_matches.group_by do |matches|
            count_duplicate_matches(matches_counts, matches)
          end.min_by(&:first).last

          # Pick the pairings with least total score difference
          min_pairings = Util.all_min_by(min_pairings) do |matches|
            score_difference(scores, matches)
          end

          # Pick the last one as its usually the most diverse
          min_pairings.last
        end

        private

        def count_duplicate_matches(matches_counts, matches)
          matches.map { |match| matches_counts[Set.new match] || 0 }.reduce(:+)
        end

        def score_difference(scores, matches)
          # Default to a score of 0
          score_h = Hash.new { |hash, key| hash[key] = scores[key] || 0 }

          matches.map { |match| (score_h[match[0]] - score_h[match[1]]).abs }
                 .reduce(:+)
        end
      end
    end
  end
end
