require 'ostruct'

require 'tournament-system'

class TestDriver < Tournament::Driver
  def initialize(options = {}, &block)
    @teams = options[:teams]
    @matches = options[:matches] || {}
    @winners = options[:winners] || {}
    @created_matches = []
  end

  attr_accessor :teams
  attr_accessor :created_matches

  def seeded_teams
    @teams
  end

  def matches_for_round(round)
    @matches[round]
  end

  def matches
    @matches.values.reduce(:+) || []
  end

  def get_match_winner(match)
    @winners[match]
  end

  def build_match(home_team, away_team)
    @created_matches << OpenStruct.new(home_team: home_team, away_team: away_team)
  end

  def test_matches
    @matches
  end

  def test_matches=(value)
    @matches = value
  end
end
