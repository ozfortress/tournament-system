describe Tournament::RoundRobin do
  describe '#total_rounds' do
    it 'works for valid input' do
      driver = TestDriver.new(teams: [1, 2, 3])
      expect(described_class.total_rounds driver).to eq(3)

      driver = TestDriver.new(teams: [1, 2])
      expect(described_class.total_rounds driver).to eq(1)

      driver = TestDriver.new(teams: [1, 2, 3, 4, 5, 6])
      expect(described_class.total_rounds driver).to eq(5)

      driver = TestDriver.new(teams: (1..9).to_a)
      expect(described_class.total_rounds driver).to eq(9)
    end
  end

  describe '#guess_round' do
    it 'works for valid input' do
      driver = TestDriver.new(teams: [1, 2, 3, 4], matches: {})
      expect(described_class.guess_round driver).to eq(0)

      driver.test_matches[1] = [1, 2]
      expect(described_class.guess_round driver).to eq(1)

      driver.test_matches[1] = [1, 2, 3, 4]
      expect(described_class.guess_round driver).to eq(2)

      driver.test_matches[1] = [1, 2, 3, 4, 5, 6]
      expect(described_class.guess_round driver).to eq(3)

      driver.test_matches[1] = [1, 2, 3, 4, 5, 6, 7, 8]
      expect(described_class.guess_round driver).to eq(4)
    end
  end

  describe '#generate' do
    context 'first round' do
      it 'works for 4 teams' do
        driver = TestDriver.new(teams: [1, 2, 3, 4])

        described_class.generate driver

        expect(driver.created_matches.length).to eq(2)
        match1, match2 = driver.created_matches
        expect(match1.home_team).to eq(1)
        expect(match1.away_team).to eq(4)
        expect(match2.home_team).to eq(2)
        expect(match2.away_team).to eq(3)
      end

      it 'works for 5 teams' do
        driver = TestDriver.new(teams: [1, 2, 3, 4, 5])

        described_class.generate driver

        expect(driver.created_matches.length).to eq(3)
        match1, match2, match3 = driver.created_matches
        expect(match1.home_team).to eq(1)
        expect(match1.away_team).to be nil
        expect(match2.home_team).to eq(2)
        expect(match2.away_team).to eq(5)
        expect(match3.home_team).to eq(3)
        expect(match3.away_team).to eq(4)
      end
    end

    context 'full tournament' do
      it 'works for 4 teams' do
        driver = TestDriver.new(teams: [1, 2, 3, 4])

        (0...3).each do |round|
          described_class.generate driver, round: round
          driver.test_matches[round] = driver.created_matches.map do |match|
            [match.home_team, match.away_team]
          end
          driver.created_matches = []
        end

        expect(driver.matches.length).to eq(6)
        # Ensure every team faces the other exactly once
        driver.seeded_teams.each do |team1|
          driver.seeded_teams.each do |team2|
            next if team1 == team2

            expect(driver.matches.count do |match|
              match.include?(team1) && match.include?(team2)
            end).to eq(1)
          end
        end
      end

      it 'works for 5 teams' do
        driver = TestDriver.new(teams: [1, 2, 3, 4, 5])

        (0...5).each do |round|
          described_class.generate driver, round: round
          driver.test_matches[round] = driver.created_matches.map do |match|
            [match.home_team, match.away_team]
          end
          driver.created_matches = []
        end

        expect(driver.matches.length).to eq(15)
        # Ensure every team faces the other exactly once
        driver.seeded_teams.each do |team1|
          driver.seeded_teams.each do |team2|
            next if team1 == team2

            expect(driver.matches.count do |match|
              match.include?(team1) && match.include?(team2)
            end).to eq(1)
          end
        end
      end
    end
  end
end
