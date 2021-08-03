require 'ostruct'

require 'tournament_system/algorithm/swiss'
require 'tournament_system/algorithm/matching'
require 'tournament_system/algorithm/group_pairing'

module TournamentSystem
  module Swiss
    # A Dutch pairing system implementation.
    module Dutch
      extend self

      # Pair teams using dutch pairing for a swiss system tournament.
      #
      # Teams are initially grouped by their score and then slide paired
      # ({TournamentSystem::Algorithm::GroupPairing.slide}). If that fails to produce unique matches it will match teams
      # by the minimum score difference, aniling duplicate matches (default) and optionally pushing byes to a certain
      # side.
      #
      # @param driver [Driver]
      # @option options [Boolean] allow_duplicates removes the penalty of duplicate matches from the pairing algorithm
      # @option options [:none, :top_half, :bottom_half] push_byes_to adds a penalty to the pairing algorithm for when a
      #     bye match is not with a team in the desired position.
      # @return [Array<Array(team, team)>] the generated pairs of teams
      def pair(driver, options = {})
        state = build_state(driver, options)

        dutch_pairings = generate_dutch_pairings(state)

        duplicates = driver.count_duplicate_matches(dutch_pairings)

        if duplicates.zero?
          dutch_pairings
        else
          generate_best_pairings(state)
        end
      end

      private

      def build_state(driver, options)
        OpenStruct.new(
          driver: driver,
          teams: get_teams(driver),
          scores: driver.scores_hash,
          allow_duplicates: options.fetch(:allow_duplicates, false),
          push_byes_to: options.fetch(:push_byes_to, :none)
        )
      end

      def get_teams(driver)
        teams = driver.ranked_teams.dup

        # Special padding such that the bottom team gets a BYE with dutch
        teams.insert(teams.length / 2, nil) if teams.length.odd?

        teams
      end

      def generate_dutch_pairings(state)
        groups = Algorithm::Swiss.group_teams_by_score(state.teams, state.scores)

        # Make sure all groups are at least of size 2
        Algorithm::Swiss.rollover_groups(groups)

        groups.map do |group|
          Algorithm::GroupPairing.slide(group)
        end.reduce(:+)
      end

      # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity

      def generate_best_pairings(state)
        teams = state.teams

        state.matches = state.driver.matches_hash

        state.score_range = state.scores.values.max - state.scores.values.min
        state.average_score_difference = state.score_range / teams.length.to_f

        state.team_index_map = teams.map.with_index.to_h

        Algorithm::Matching.minimum_weight_perfect_matching(teams) do |home_team, away_team|
          cost_function(state, home_team, away_team)
        end
      end

      # This function will be called a lot, so it needs to be pretty fast (run in +O(1)+)
      def cost_function(state, home_team, away_team)
        match_set = Set[home_team, away_team]
        cost = 0

        # Reduce score distance between teams
        cost += ((state.scores[home_team] || 0) - (state.scores[away_team] || 0)).abs

        # The cost of a duplicate is the score range + 1
        cost += (state.score_range + 1) * state.matches[match_set] unless state.allow_duplicates

        # Add cost for bye matches not on the preferred side
        push_byes_to = state.push_byes_to
        if match_set.include?(nil) && push_byes_to != :none
          index = state.team_index_map[home_team || away_team]

          if (push_byes_to == :bottom_half && index < state.teams.length / 2) ||
             (push_byes_to == :top_half && index > state.teams.length / 2)
            cost += state.score_range
          end
        end

        cost
      end

      # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
    end
  end
end
