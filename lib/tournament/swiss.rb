require 'tournament/algorithm/swiss'
require 'tournament/swiss/dutch'

module Tournament
  # Implements the swiss tournament system
  module Swiss
    extend self

    # Generate matches with the given driver.
    #
    # @param driver [Driver]
    # @option options [Pairer] pairer the pairing system to use, defaults to
    #                                 {Dutch}
    # @option options [Hash] pair_options options for the chosen pairing system,
    #                                     see {Dutch} for more details
    # @return [void]
    def generate(driver, options = {})
      pairer = options[:pairer] || Dutch
      pairer_options = options[:pair_options] || {}

      pairings = pairer.pair(driver, pairer_options)

      driver.create_matches(pairings)
    end

    # The minimum number of rounds to determine a winner.
    #
    # @param driver [Driver]
    # @return [Integer]
    def minimum_rounds(driver)
      Algorithm::Swiss.minimum_rounds(driver.seeded_teams.length)
    end
  end
end
