module Tournament
  # An interface for external tournament data.
  #
  # To use any tournament system implemented in this gem, simply subclass this
  # class and implement the interface functions.
  #
  # The interface is designed to be useable with arbitrary data,
  # meaning that as long as your data is consistent it will work with this gem.
  # Be it Ruby on Rails Models or simply integers.
  #
  # Certain tournament systems will not make use of certain parts of this
  # interface. You can for example leave out `#get_team_score` if you're not
  # using the Swiss tournament system.
  # :reek:UnusedParameters
  class Driver
    # rubocop:disable Lint/UnusedMethodArgument
    # :nocov:

    # Get all matches
    def matches
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

    # :nocov:
    # rubocop:enable Lint/UnusedMethodArgument

    # Get the losing team of a specific match
    def get_match_loser(match)
      winner = get_match_winner(match)
      get_match_teams(match).reject { |team| team == winner }.first
    end

    # Get a hash of unique team pairs and their number of occurences.
    #
    # @return [Hash{Set(team, team) => Integer}]
    def matches_hash
      @matches_hash ||= build_matches_hash
    end

    # Count the number of times each pair of teams has played.
    def count_duplicate_matches(matches)
      matches.map { |match| matches_hash[Set.new match] }.reduce(0, :+)
    end

    # Create a match.
    def create_match(home_team, away_team)
      home_team, away_team = away_team, home_team unless home_team
      raise 'Invalid match' unless home_team

      build_match(home_team, away_team)
    end

    # Create a bunch of matches.
    def create_matches(matches)
      matches.each do |home_team, away_team|
        create_match(home_team, away_team)
      end
    end

    # Get a hash of the points of all ranked teams.
    #
    # @return [Hash{team => Number}]
    def points_hash
      @points_hash = ranked_teams.map { |team| [team, get_team_score(team)] }
                                 .to_h
    end

    private

    def build_matches_hash
      matches.each_with_object(Hash.new(0)) do |match, counter|
        match = Set.new get_match_teams(match)
        counter[match] += 1
      end
    end
  end
end
