require 'tournament/algorithm/swiss'
require 'tournament/algorithm/pairers/multi'
require 'tournament/algorithm/pairers/halves'
require 'tournament/algorithm/pairers/best_min_duplicates'

module Tournament
  module Swiss
    # A simplified Dutch pairing system implementation.
    module Dutch
      extend self

      # Pair teams using dutch pairing for a swiss system tournament.
      #
      # @param driver [Driver]
      # @option options [Integer] min_pair_size see
      #     {Algorithm::Swiss#merge_small_groups for more details}
      # @return [Array<Array(team, team)>] the generated pairs of teams
      def pair(driver, options = {})
        teams = driver.ranked_teams.dup

        # Special padding such that the bottom team gets a BYE
        teams.insert(teams.length / 2, nil) if teams.length.odd?

        scores = driver.scores_hash
        groups = Algorithm::Swiss.group_teams_by_score(teams, scores)

        min_pair_size = options[:min_pair_size] || 4
        Algorithm::Swiss.merge_small_groups(groups, min_pair_size)

        Algorithm::Swiss.rollover_groups(groups)

        pair_groups driver, groups
      end

      private

      def pairer_funcs(driver, group)
        scores = driver.scores_hash
        matches = driver.matches_hash

        [
          -> () { Algorithm::Pairers::Halves.pair(group) },
          lambda do
            Algorithm::Pairers::BestMinDuplicates.pair(group, scores, matches)
          end,
        ]
      end

      def pair_groups(driver, groups)
        groups.map { |group| pair_group(driver, group) }.reduce(:+)
      end

      def pair_group(driver, group)
        Algorithm::Pairers::Multi.pair(pairer_funcs(driver, group)) do |matches|
          duplicates = driver.count_duplicate_matches(matches)

          # Early return when there are no duplicates, prefer earlier pairers
          return matches if duplicates.zero?

          -duplicates
        end
      end
    end
  end
end
