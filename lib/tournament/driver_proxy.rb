module Tournament
  # Proxies a driver, allowing overriding of certain functions.
  #
  # Used by tournament systems that build on top of others, with special behaviour.
  # By default the behaviour is identical to the proxied driver.
  class DriverProxy < Driver
    # :nocov:

    # @param target [Driver] the driver to proxy
    def initialize(target)
      @target = target
    end

    def matches
      @target.matches
    end

    def seeded_teams
      @target.seeded_teams
    end

    def ranked_teams
      @target.ranked_teams
    end

    def get_match_winner(match)
      @target.get_match_winner(match)
    end

    def get_match_teams(match)
      @target.get_match_teams(match)
    end

    def get_team_score(team)
      @target.get_team_score(team)
    end

    def get_team_matches(team)
      @target.get_team_matches(team)
    end

    def build_match(home_team, away_team)
      @target.build_match(home_team, away_team)
    end
  end
end
