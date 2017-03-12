module Tournament
  module RoundRobin
    extend self

    def generate(driver, options = {})
      round = options[:round] || guess_round(driver)

      teams = seed_teams driver.seeded_teams, options

      teams = rotate_to_round teams, round

      create_matches driver, teams, round
    end

    def total_rounds(driver)
      team_count(driver) - 1
    end

    def guess_round(driver)
      match_count = driver.matches.length

      match_count / (team_count(driver) / 2)
    end

    private

    def team_count(driver)
      count = driver.seeded_teams.length
      count += 1 if count.odd?
      count
    end

    def seed_teams(teams, options)
      teams << nil if teams.length.odd?

      seeder = options[:seeder] || Seeder::None
      seeder.seed teams
    end

    def rotate_to_round(teams, round)
      rotateable = teams[1..-1]

      [teams[0]] + rotateable.rotate(-round)
    end

    def create_matches(driver, teams, round)
      teams[0...teams.length / 2].each_with_index do |home_team, index|
        away_team = teams[-index - 1]

        # Alternate home/away
        home_team, away_team = away_team, home_team if round.odd?

        driver.create_match(home_team, away_team)
      end
    end
  end
end
