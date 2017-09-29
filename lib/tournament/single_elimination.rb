require 'tournament/algorithm/single_bracket'
require 'tournament/algorithm/group_pairing'

module Tournament
  # Implements the single bracket elimination tournament system.
  module SingleElimination
    extend self

    # Generate matches with the given driver
    #
    # @param driver [Driver]
    # @return [nil]
    def generate(driver, _options = {})
      round = guess_round(driver)

      teams = if driver.matches.empty?
                padded = Algorithm::SingleBracket.padd_teams driver.seeded_teams
                Algorithm::SingleBracket.seed padded
              else
                last_matches = previous_round_matches driver, round
                get_match_winners driver, last_matches
              end

      driver.create_matches Algorithm::GroupPairing.adjacent(teams)
    end

    # The total number of rounds needed for a single elimination tournament with
    # the given driver.
    #
    # @param driver [Driver]
    # @return [Integer]
    def total_rounds(driver)
      Algorithm::SingleBracket.total_rounds(driver.seeded_teams.length)
    end

    # Guess the next round number (starting at 0) from the state in driver.
    #
    # @param driver [Driver]
    # @return [Integer]
    def guess_round(driver)
      Algorithm::SingleBracket.guess_round(driver.seeded_teams.length,
                                           driver.matches.length)
    end

    private

    def get_match_winners(driver, matches)
      matches.map { |match| driver.get_match_winner(match) }
    end

    def previous_round_matches(driver, round)
      rounds_left = total_rounds(driver) - round
      previous_matches_count = 2**rounds_left

      driver.matches.last(previous_matches_count)
    end
  end
end
