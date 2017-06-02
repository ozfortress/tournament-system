module Tournament
  module Swiss
    # Common functions for swiss pairing systems..\
    module Common
      extend self

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
      # rubocop:disable Metrics/MethodLength :reek:TooManyStatements
      def merge_small_groups(groups, group_keys, min_size)
        new_keys = []

        group_keys.each_with_index do |key, index|
          group = groups[key]

          # Merge small groups into an adjacent group
          if group.length < min_size
            groups.delete(key)

            # When there is an adjacent lesser group, merge into that one
            new_key = group_keys[index + 1]
            if new_key
              groups[new_key] = group + groups[new_key]
            # If there isn't, merge into the adjacent greater group
            else
              new_key = new_keys[-1]

              if new_key
                groups[new_key] += group
              else
                # If there are no new keys just use the current key
                new_keys << key
                groups[key] = group
              end
            end
          # Leave larger groups the way they are
          else
            new_keys << key
            groups[key] = group
          end
        end

        new_keys
      end
      # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

      # Get a set of already played matches. Matches are also sets
      def matches_set(driver)
        existing_matches = Hash.new
        driver.matches.each do |match|
          match_teams = Set.new driver.get_match_teams match
          existing_matches[match_teams] ||= 0
          existing_matches[match_teams] += 1
        end
        existing_matches
      end

      # Check whether any match has already been played
      def any_match_exists?(matches, existing_matches)
        matches.any? { |match| existing_matches.include?(Set.new(match)) }
      end

      # Count the number of matches already played
      def count_existing_matches(matches, existing_matches)
        matches.map { |match| existing_matches[Set.new(match)] || 0 }.reduce(:+)
      end

      # Finds the first permutation of teams that has a unique pairing.
      # If none are found, the pairing that has the least duplicate matches
      # is returned.
      # rubocop:disable Metrics/MethodLength
      def first_permutation_pairing(teams, existing_matches)
        min_dups = Float::INFINITY
        best_matches = nil

        # Find the first permutation that has no duplicate matches
        # Or the permutation with the least duplicate matches
        teams.permutation.each do |variation|
          matches = (yield variation).to_a
          dup_count = count_existing_matches(matches, existing_matches)

          # Quick exit when there are no duplicates
          return matches if dup_count.zero?

          # Update best stats as we go along
          if dup_count < min_dups
            min_dups = dup_count
            best_matches = matches
          end
        end

        best_matches
      end
      # rubocop:enable Metrics/MethodLength
    end
  end
end
