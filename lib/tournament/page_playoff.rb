module Tournament
  module PagePlayoff
    extend self

    def generate(driver, options = {})
      teams = driver.ranked_teams
      raise 'Page Playoffs only works with 4 teams' if teams.length != 4

      round = options[:round] || guess_round(driver)

      case round
      when 0 then semi_finals(driver, teams)
      when 1 then preliminary_finals(driver)
      when 2 then grand_finals(driver, options)
      else
        raise 'Invalid round number'
      end
    end

    def total_rounds
      3
    end

    def guess_round(driver)
      count = driver.matches.length

      case count
      when 0 then 0
      when 2 then 1
      when 3 then 2
      else
        raise 'Invalid number of matches'
      end
    end

    private

    def create_matches(driver, matches)
      matches.each do |match|
        driver.create_match match[0], match[1]
      end
    end

    def semi_finals(driver, teams)
      create_matches driver, [[teams[0], teams[1]], [teams[2], teams[3]]]
    end

    def preliminary_finals(driver)
      matches = driver.matches
      top_loser = driver.get_match_loser matches[0]
      bottom_winner = driver.get_match_winner matches[1]

      driver.create_match top_loser, bottom_winner
    end

    def grand_finals(driver, options)
      matches = driver.matches
      top_winner = driver.get_match_winner matches[0]
      bottom_winner = driver.get_match_winner matches[2]

      driver.create_match top_winner, bottom_winner

      bronze_finals(driver, matches) if options[:bronze_match]
    end

    def bronze_finals(driver, matches)
      prelim_loser = driver.get_match_loser matches[2]
      bottom_semi_loser = driver.get_match_loser matches[1]

      driver.create_match prelim_loser, bottom_semi_loser
    end
  end
end
