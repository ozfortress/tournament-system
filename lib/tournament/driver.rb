module Tournament
  # An interface for external tournament data.
  #
  # To use any tournament system implemented in this gem, simply subclass this
  # class and implement the interface functions.
  # :reek:UnusedParameters
  class Driver
    # rubocop:disable Lint/UnusedMethodArgument

    # Get all matches
    def matches
      raise 'Not Implemented'
    end

    # Get the matches played for a particular round
    def matches_for_round(round)
      raise 'Not Implemented'
    end

    # Get the teams playing with their initial seedings
    def seeded_teams
      raise 'Not Implemented'
    end

    # Get the teams playing, ranked by their current position in the tournament
    def ranked_teams
      raise 'Not Implemented'
    end

    # Get the winning team of a match
    def get_match_winner(match)
      raise 'Not Implemented'
    end

    # Get both teams playing for a match
    def get_match_teams(match)
      raise 'Not Implemented'
    end

    # Get a specific score for a team
    def get_team_score(team)
      raise 'Not Implemented'
    end

    # Handle for matches that are created by tournament systems
    def build_match(home_team, away_team)
      raise 'Not Implemented'
    end

    # rubocop:enable Lint/UnusedMethodArgument

    # Get the losing team of a specific match
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
