module TournamentSystem
  # :reek:UnusedParameters :reek:TooManyMethods

  # An interface for external tournament data.
  #
  # To use any tournament system implemented in this gem, simply subclass this class and implement the interface
  # functions.
  #
  # The interface is designed to be useable with arbitrary data, meaning that as long as your data is consistent it will
  # work with this gem. Be it Ruby on Rails Models or simply integers.
  #
  # Certain tournament systems will not make use of certain parts of this interface. You can for example leave out
  # `#get_team_score` if you're not using the Swiss tournament system.
  #
  # This class caches certain calculations/objects, it is designed to be a one-time use with any one tournament system.
  # Reusing an instance is undefined behaviour.
  #
  # @example Example of Rails models and a tournament system driver
  #   class Tournament < ActiveRecord::Base
  #     has_many :matches
  #     has_many :teams
  #   end
  #
  #   class Match < ActiveRecord::Base
  #     belongs_to :tournament
  #     belongs_to :team1, class_name: 'Team'
  #     belongs_to :team2, class_name: 'Team'
  #     belongs_to :winner, class_name: 'Team'
  #   end
  #
  #   class Team < ActiveRecord::Base
  #     belongs_to :tournament
  #
  #     validates :seed, numericality: { only_integer: true }
  #     validates :points, numericality: { only_integer: true }
  #   end
  #
  #   class Driver < TournamentSystem
  #     def initialize(tournament)
  #       @tournament = tournament
  #     end
  #
  #     def matches
  #       @tournament.matches
  #     end
  #
  #     def seeded_teams
  #       @tournament.teams.order(:seed).to_a
  #     end
  #
  #     def ranked_teams
  #       @tournament.teams.order(:points).to_a
  #     end
  #
  #     def get_match_winner(match)
  #       match.winner
  #     end
  #
  #     def get_match_teams(match)
  #       [match.team1, match.team2]
  #     end
  #
  #     def get_team_score(team)
  #       team.points
  #     end
  #
  #     def get_team_matches(team)
  #       @tournament.matches.where(team1: team) +
  #         @tournament.matches.where(team2: team)
  #     end
  #
  #     def build_match(home_team, away_team)
  #       @tournament.matches.create!(team1: home_team, team2: away_team)
  #     end
  #   end
  class Driver
    # rubocop:disable Lint/UnusedMethodArgument
    # :nocov:

    # Required to implement: Get all matches.
    #
    # @return [Array<match>]
    def matches
      raise 'Not Implemented'
    end

    # Required to implement: Get the teams with their initial seedings.
    #
    # @return [Array<team>]
    def seeded_teams
      raise 'Not Implemented'
    end

    # Required to implement: Get the teams ranked by their current position in the tournament.
    #
    # @return [Array<team>]
    def ranked_teams
      raise 'Not Implemented'
    end

    # Required to implement: Get the winning team of a match.
    #
    # @param match [] a match, eg. one returned by {#matches}
    # @return [team, nil] the winner of the match if applicable
    def get_match_winner(match)
      raise 'Not Implemented'
    end

    # Required to implement: Get the pair of teams playing for a match.
    #
    # @param match [] a match, eg. one returned by {#matches}
    # @return [Array(team, team)] the pair of teams playing in the match
    def get_match_teams(match)
      raise 'Not Implemented'
    end

    # Required to implement: Get a specific score for a team.
    #
    # @param team [] a team, eg. one returned by {#seeded_teams}
    # @return [Number] the score of the team
    def get_team_score(team)
      raise 'Not Implemented'
    end

    # Required to implement: Get the matches a team has participated in.
    #
    # @param team [] a team, eg. one returned by {#seeded_teams}
    # @return [Array<match>] a list of matches the team has played in
    def get_team_matches(team)
      raise 'Not Implemented'
    end

    # Required to implement: Called when a match is created by a tournament system.
    #
    # @example rails
    #   def build_match(home_team, away_team)
    #     Match.create!(home_team, away_team)
    #   end
    #
    # @param home_team [team] the home team for the match, never +nil+
    # @param away_team [team, nil] the away team for the match, may be +nil+ for
    #     byes.
    # @return [nil]
    def build_match(home_team, away_team)
      raise 'Not Implemented'
    end

    # :nocov:
    # rubocop:enable Lint/UnusedMethodArgument

    # Get the losing team of a specific match. By default uses {#get_match_winner} and {#get_match_teams} to determine
    # which team lost. Override if you have better access to this information.
    #
    # @return [team, nil] the lower of the match, if applicable
    def get_match_loser(match)
      winner = get_match_winner(match)

      return nil unless winner
      get_match_teams(match).reject { |team| team == winner }.first
    end

    # Determine whether a specific match was a bye? By default uses {#get_match_teams} to determine a bye. Override if
    # you have better access to this information.
    #
    # @return [Boolean]
    def match_bye?(match)
      get_match_teams(match).include?(nil)
    end

    # Get a list of matches that weren't byes. Used by tournament systems.
    #
    # @return [Array<match>]
    def non_bye_matches
      matches.reject { |match| match_bye?(match) }
    end

    # Get a hash of unique team pairs and their number of occurences. Used by tournament systems.
    #
    # @return [Hash{Set(team, team) => Integer}]
    def matches_hash
      @matches_hash ||= build_matches_hash
    end

    # Get a hash of the matches teams have played in. Used by tournament systems.
    #
    # @return [Hash{team => Array<match>}]
    def team_matches_hash
      @team_matches_hash ||= build_team_matches_hash
    end

    # Count the number of times each pair of teams has played already. Used by tournament systems.
    #
    # @param matches [Array<match>]
    # @return [Integer] the number of duplicate matches
    def count_duplicate_matches(matches)
      matches.map { |match| matches_hash[Set.new match] }.reduce(0, :+)
    end

    # Create a match. Used by tournament systems.
    #
    # Specially handles byes, swapping home/away if required.
    #
    # @param home_team [team, nil]
    # @param away_team [team, nil]
    # @return [match]
    # @raise when both teams are +nil+
    def create_match(home_team, away_team)
      home_team, away_team = away_team, home_team unless home_team
      raise 'Invalid match' unless home_team

      build_match(home_team, away_team)
    end

    # Create a bunch of matches. Used by tournament systems.
    # @see #create_match
    #
    # @param pairs [Array<Array(team, team)>] a collection of pairs
    # @return [Array<match>]
    def create_matches(pairs)
      pairs.map do |home_team, away_team|
        create_match(home_team, away_team)
      end
    end

    # Get a hash of the scores of all ranked teams. Used by tournament systems.
    #
    # @return [Hash{team => Number}] a mapping from teams to scores
    def scores_hash
      @scores_hash ||= ranked_teams.map { |team| [team, get_team_score(team)] }.to_h
    end

    # Get a hash of the number of losses of each team. Used by tournament systems.
    #
    # @return [Hash{team => Number}] a mapping from teams to losses
    def loss_count_hash
      @loss_count_hash ||= matches.each_with_object(Hash.new(0)) { |match, hash| hash[get_match_loser(match)] += 1 }
    end

    private

    def build_matches_hash
      matches.each_with_object(Hash.new(0)) do |match, counter|
        match = Set.new get_match_teams(match)
        counter[match] += 1
      end
    end

    def build_team_matches_hash
      seeded_teams.each_with_object({}) do |team, hash|
        matches = get_team_matches(team)
        hash[team] = matches
      end
    end
  end
end
