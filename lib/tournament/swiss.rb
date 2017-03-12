require 'tournament/swiss/common'
require 'tournament/swiss/dutch'

module Tournament
  module Swiss
    extend self

    def generate(driver, options = {})
      pairer = options[:pairer] || Dutch
      pairer_options = options[:pair_options] || {}

      teams = seed_teams driver.ranked_teams, options

      pairings = pairer.pair driver, teams, pairer_options

      create_matches driver, pairings
    end

    def minimum_rounds(driver)
      team_count = driver.seeded_teams.length

      Math.log2(team_count).ceil
    end

    private

    def seed_teams(teams, options)
      seeder = options[:seeder] || Seeder::None
      seeder.seed teams
    end

    def create_matches(driver, pairings)
      pairings.each do |pair|
        driver.create_match(pair[0], pair[1])
      end
    end
  end
end
