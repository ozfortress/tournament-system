module Tournament
  # Implements the single bracket elimination tournament system.
  module SingleElimination
    extend self

    def generate(driver, options = {})
      round = options[:round] || raise('Missing option :round')

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

    private

    def seed_teams(teams, options)
      teams = padd_teams teams

      seeder = options[:seeder] || Seeder::SingleBracket
      seeder.seed teams
    end

    def padd_teams(teams)
      # Insert the padding after the top half of the total number of teams
      total = 2**total_rounds_for_teams(teams)
      half = total / 2

      padding = total - teams.length

      teams[0...half] + [nil] * padding + teams[half...teams.length]
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
