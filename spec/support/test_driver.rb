require 'ostruct'

require 'tournament_system'

class Match < Array
  def home_team
    first
  end

  def away_team
    last
  end
end

class TestDriver < TournamentSystem::Driver
  def initialize(options = {})
    @teams = options[:teams] || []
    @matches = options[:matches] || []
    @winners = options[:winners] || {}
    @scores = options[:scores] || Hash.new(0)
    @ranked_teams = options[:ranked_teams] || @teams
    @team_matches = options[:team_matches] || build_team_matches_from_matches
    @created_matches = []
    super()
  end
  attr_accessor :scores, :teams, :ranked_teams, :matches, :created_matches

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

  def get_team_matches(team)
    @team_matches[team]
  end

  def build_match(home_team, away_team)
    match = Match.new([home_team, away_team])
    @created_matches << match
    match
  end

  private

  def build_team_matches_from_matches
    result = {}
    @teams.each { |team| result[team] = [] }

    @matches.each do |match|
      match.reject(&:nil?).each do |team|
        result[team] << match if result.include?(team)
      end
    end

    result
  end
end
