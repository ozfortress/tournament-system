module Tournament
  module Swiss
    module Common
      extend self

      private

      # Iterate over each group, letting a team rollover into the next group
      # if a group has an odd number of teams
      def each_group_with_rollover(groups, group_keys)
        group_keys.each_with_index do |key, index|
          group = groups[key]
          # Drop teams to next group get an even number
          next_key = group_keys[index + 1]
          groups[next_key] << group.pop if group.length.odd? && next_key

          yield group
        end
      end

      # Groups teams by the score given by the driver
      def group_teams_by_score(driver, teams)
        groups = teams.group_by { |team| driver.get_team_score team }
        group_keys = groups.keys.sort.reverse.to_a

        [groups, group_keys]
      end

      # Merges small groups to the right (if possible) such that all groups
      # are larger than min_size.
      def merge_small_groups(groups, group_keys, min_size)
        new_keys = []

        group_keys.each_with_index do |key, index|
          group = groups[key]

          if group.length < min_size
            groups.delete(key)

            new_key = group_keys[index + 1]
            if new_key
              groups[new_key] = group + groups[new_key]
            else
              new_key = group_keys[index - 1] unless new_key
              groups[new_key] += group
            end
          else
            new_keys << key
            groups[key] = group
          end
        end

        [groups, new_keys]
      end

      # Get a fast set of already played matches
      def matches_set(driver)
        existing_matches = Set.new
        driver.matches.each do |match|
          match_teams = driver.get_match_teams match
          existing_matches.add Set.new match_teams
        end
        existing_matches
      end

      # Check whether any match has already been played
      def any_match_exists?(matches, existing_matches)
        matches.any? { |match| existing_matches.include?(Set.new match) }
      end

      # Finds the first permutation of teams that has a unique pairing.
      # If none are found, the pairing that has the least duplicate matches
      # is returned.
      def first_permutation_pairing(teams, existing_matches)
        min_dups = Float::INFINITY
        best_matches = nil

        teams.permutation.each do |variation|
          matches = (yield variation).to_a
          dup_count = matches.count { |match| existing_matches.include?(Set.new match) }

          if dup_count == 0
            return matches
          elsif dup_count < min_dups
            best_matches = matches
          end
        end

        best_matches
      end
    end
  end
end
