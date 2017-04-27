module Tournament
  # Implements the single bracket elimination tournament system.
  module SingleElimination
    extend self

    def generate(driver, options = {})
      round = options[:round] || guess_round(driver)

      teams = if driver.matches.empty?
                seed_teams driver.seeded_teams, options
              else
                last_matches = driver.matches_for_round(round - 1)
                get_match_winners driver, last_matches
              end

      create_matches driver, teams
    end

    def total_rounds(driver)
      total_rounds_for_teams(driver.seeded_teams)
    end

    def guess_round(driver)
      rounds = total_rounds(driver)
      teams_count = 2**rounds
      matches_count = driver.matches.length
      # Make sure we don't have too many matches
      raise ArgumentError, 'Too many matches' unless teams_count > matches_count

      round = rounds - Math.log2(teams_count - matches_count)
      # Make sure we don't have some weird number of matches
      raise ArgumentError, 'Invalid number of matches' unless (round % 1).zero?
      round.to_i
    end

    private

    def seed_teams(teams, options)
      teams = padd_teams teams

      seeder = options[:seeder] || Seeder::SingleBracket
      seeder.seed teams
    end

    def padd_teams(teams)
      required = 2**total_rounds_for_teams(teams)
      padding = required - teams.length

      # Insert the padding at the bottom to give top teams byes
      teams + [nil] * padding
    end

    def total_rounds_for_teams(teams)
      team_count = teams.length

      Math.log2(team_count).ceil
    end

    def get_match_winners(driver, matches)
      matches.map { |match| driver.get_match_winner(match) }
    end

    def create_matches(driver, teams)
      teams.each_slice(2) do |slice|
        next if slice.all?(&:nil?)

        driver.create_match(slice[0], slice[1])
      end
    end
  end
end
