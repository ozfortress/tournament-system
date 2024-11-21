require 'tournament_system/algorithm/double_bracket'
require 'tournament_system/algorithm/group_pairing'

module TournamentSystem
  # Implements the double bracket elimination tournament system.
  module DoubleElimination
    extend self

    # Generate matches with the given driver
    #
    # @param driver [Driver]
    # @return [nil]
    def generate(driver, _options = {})
      round = guess_round driver

      teams_padded = Algorithm::Util.padd_teams_pow2 driver.seeded_teams
      teams_seeded = Algorithm::DoubleBracket.seed teams_padded

      teams = if driver.matches.empty?
                teams_seeded
              else
                get_round_teams driver, round, teams_seeded
              end

      driver.create_matches Algorithm::GroupPairing.adjacent(teams)
    end

    # The total number of rounds needed for a single elimination tournament with
    # the given driver.
    #
    # @param driver [Driver]
    # @return [Integer]
    def total_rounds(driver)
      Algorithm::DoubleBracket.total_rounds(driver.seeded_teams.length)
    end

    # Guess the next round number (starting at 0) from the state in driver.
    #
    # @param driver [Driver]
    # @return [Integer]
    def guess_round(driver)
      Algorithm::DoubleBracket.guess_round(driver.seeded_teams.length,
                                           driver.non_bye_matches.length)
    end

    private

    def get_round_teams(driver, round, teams_seeded)
      loss_counts = driver.loss_count_hash

      winners = teams_seeded.select { |team| loss_counts[team].zero? }
      losers  = teams_seeded.select { |team| loss_counts[team] == 1 }

      if Algorithm::DoubleBracket.minor_round?(round)
        winners + losers
      elsif Algorithm::DoubleBracket.major_round?(round)
        losers
      else
        winners
      end
    end
  end
end
