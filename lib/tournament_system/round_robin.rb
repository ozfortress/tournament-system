require 'tournament_system/algorithm/util'
require 'tournament_system/algorithm/round_robin'

module TournamentSystem
  # Implements the round-robin tournament system.
  module RoundRobin
    extend self

    # Generate matches with the given driver.
    #
    # @param driver [Driver]
    # @option options [Integer] round the round to generate
    # @return [nil]
    def generate(driver, options = {})
      round = options[:round] || guess_round(driver)

      teams = Algorithm::Util.padd_teams_even(driver.seeded_teams)

      matches = Algorithm::RoundRobin.round_robin_pairing(teams, round)

      create_matches driver, matches, round
    end

    # The total number of rounds needed for a round robin tournament with the
    # given driver.
    #
    # @param driver [Driver]
    # @return [Integer]
    def total_rounds(driver)
      Algorithm::RoundRobin.total_rounds(driver.seeded_teams.length)
    end

    # Guess the next round number (starting at 0) from the state in driver.
    #
    # @param driver [Driver]
    # @return [Integer]
    def guess_round(driver)
      Algorithm::RoundRobin.guess_round(driver.seeded_teams.length,
                                        driver.matches.length)
    end

    private

    def create_matches(driver, matches, round)
      matches.each do |match|
        # Alternate home/away
        match = match.reverse if round.odd? && match[0]

        driver.create_match(*match)
      end
    end
  end
end
