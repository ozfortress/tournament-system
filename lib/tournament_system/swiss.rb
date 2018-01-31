require 'tournament_system/algorithm/swiss'
require 'tournament_system/swiss/dutch'
require 'tournament_system/swiss/accelerated_dutch'

module TournamentSystem
  # Robust implementation of the swiss tournament system
  module Swiss
    extend self

    # Generate matches with the given driver.
    #
    # @param driver [Driver]
    # @option options [Pairer] pairer the pairing system to use, defaults to
    #                                 {Dutch}
    # @option options [Hash] pair_options options for the chosen pairing system,
    #                                     see {Dutch} for more details
    # @return [nil]
    def generate(driver, options = {})
      pairer = options[:pairer] || Dutch
      pairer_options = options[:pair_options] || {}

      pairings = pairer.pair(driver, pairer_options)

      driver.create_matches(pairings)
    end

    # Guesses the round number (starting from 0) from the maximum amount of matches any team has played.
    # The guess will be wrong for long running competitions where teams are free to sign up and drop out at any time.
    #
    # @param driver [Driver]
    # @return [Integer]
    def guess_round(driver)
      driver.team_matches_hash.values.map(&:length).max || 0
    end

    # The minimum number of rounds to determine a number of winners.
    #
    # @param driver [Driver]
    # @return [Integer]
    def minimum_rounds(driver)
      Algorithm::Swiss.minimum_rounds(driver.seeded_teams.length)
    end
  end
end
