module Tournament
  class Driver
    # rubocop:disable Lint/UnusedMethodArgument
    def matches_for_round(round)
      raise 'Not Implemented'
    end

    def seeded_teams
      raise 'Not Implemented'
    end

    def ranked_teams
      raise 'Not Implemented'
    end

    def get_match_winner(match)
      raise 'Not Implemented'
    end

    def get_match_teams(match)
      raise 'Not Implemented'
    end

    def get_team_score(team)
      raise 'Not Implemented'
    end

    def build_match(home_team, away_team)
      raise 'Not Implemented'
    end

    # rubocop:enable Lint/UnusedMethodArgument

    def get_match_loser(match)
      winner = get_match_winner(match)
      get_match_teams(match).reject { |team| team == winner }.first
    end

    def create_match(home_team, away_team)
      home_team, away_team = away_team, home_team unless home_team
      raise 'Invalid match' unless home_team

      build_match(home_team, away_team)
    end
  end
end
