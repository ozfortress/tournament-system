require 'ostruct'

require 'tournament-system'

class TestDriver < Tournament::Driver
  def initialize(options = {})
    @teams = options[:teams] || []
    @ranked_teams = options[:ranked_teams] || @teams
    @matches = options[:matches] || []
    @winners = options[:winners] || {}
    @scores = options[:scores] || Hash.new(0)
    @created_matches = []
  end

  attr_accessor :scores
  attr_accessor :teams
  attr_accessor :ranked_teams
  attr_accessor :matches
  attr_accessor :created_matches

  def seeded_teams
    @teams
  end

  def get_match_teams(match)
    match
  end

  def get_match_winner(match)
    @winners[match]
  end

  def get_team_score(team)
    @scores[team]
  end

  def build_match(home_team, away_team)
    @created_matches << OpenStruct.new(home_team: home_team,
                                       away_team: away_team)
  end
end
