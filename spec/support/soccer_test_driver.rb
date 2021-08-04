require 'ostruct'

require 'tournament_system'

class SoccerTestDriver < TestDriver
  def initialize(options = {})
    super(options)
    @scores = options[:scores] || scores_from_winners(@teams, @winners)
    @matches = options[:matches] || @winners.keys.to_a
    @ranked_teams = options[:ranked_teams] || @teams.sort_by { |t| @scores[t] }
    @team_matches = options[:team_matches] || build_team_matches_from_matches
  end

  private

  def scores_from_winners(_teams, winners)
    scores = Hash.new(0)
    winners.each do |_match, winner|
      scores[winner] += 3
    end
    scores
  end
end
