module Tournament
  module Swiss
    module Dutch
      extend self
      extend Common

      def pair(driver, teams, options = {})
        return dutch_pairing(teams) if driver.matches.empty?

        groups, group_keys = group_teams_by_score(driver, teams)

        min_pair_size = options[:min_pair_size] || 4
        groups, group_keys = merge_small_groups(groups, group_keys, min_pair_size)

        existing_matches = matches_set(driver)

        matches = []
        each_group_with_rollover(groups, group_keys) do |group|
          pairs = dutch_pairing(group)
          if any_match_exists?(pairs, existing_matches)
            pairs = first_permutation_pairing(group, existing_matches) do |p|
              dutch_pairing(p)
            end
          end

          matches += pairs
        end

        matches
      end

      def dutch_pairing(teams)
        half = teams.length / 2
        top = teams[0...half]
        bottom = teams[half..-1]
        top << nil if top.length < bottom.length

        top.zip(bottom).to_a
      end

      def fix_matches(teams, pairs, existing_matches)
        if any_match_exists?(pairs, existing_matches)
          first_permutation_pairing(teams, existing_matches)
        else
          pairs
        end
      end
    end
  end
end
