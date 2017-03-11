# frozen_string_literal: true

module Tournament
  class Driver
    def matches_for_round(round)
      raise 'Not Implemented'
    end

    def teams
      raise 'Not Implemented'
    end

    def get_match_winner(match)
      raise 'Not Implemented'
    end

    def build_match(home_team, away_team)
      raise 'Not Implemented'
    end

    def create_match(home_team, away_team)
      home_team, away_team = away_team, home_team unless home_team
      raise 'Invalid match' unless home_team

      build_match(home_team, away_team)
    end
  end
end
