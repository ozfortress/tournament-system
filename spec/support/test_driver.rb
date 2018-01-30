require 'ostruct'

require 'tournament_system'

class TestDriver < TournamentSystem::Driver
  # rubocop:disable Metrics/CyclomaticComplexity
  def initialize(options = {})
    @teams = options[:teams] || []
    @ranked_teams = options[:ranked_teams] || @teams
    @matches = options[:matches] || []
    @winners = options[:winners] || {}
    @scores = options[:scores] || Hash.new(0)
    @team_matches = options[:team_matches] || build_team_matches_from_matches
    @created_matches = []
  end
  # rubocop:enable Metrics/CyclomaticComplexity

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

  def get_team_matches(team)
    @team_matches[team]
  end

  def build_match(home_team, away_team)
    @created_matches << OpenStruct.new(home_team: home_team,
                                       away_team: away_team)
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
