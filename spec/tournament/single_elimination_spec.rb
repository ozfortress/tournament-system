describe Tournament::SingleElimination do
  describe '#total_rounds' do
    it 'works for valid input' do
      driver = TestDriver.new(teams: [1, 2, 3])
      expect(described_class.total_rounds(driver)).to eq(2)

      driver = TestDriver.new(teams: [1, 2])
      expect(described_class.total_rounds(driver)).to eq(1)

      driver = TestDriver.new(teams: [1])
      expect(described_class.total_rounds(driver)).to eq(0)

      driver = TestDriver.new(teams: (1..9).to_a)
      expect(described_class.total_rounds(driver)).to eq(4)
    end
  end

  describe '#generate' do
    context 'first round' do
      it 'works for 4 teams' do
        driver = TestDriver.new(teams: [1, 2, 3, 4])
        described_class.generate driver, round: 0

        expect(driver.created_matches.length).to eq(2)
        match1, match2 = driver.created_matches
        expect(match1.home_team).to eq(1)
        expect(match1.away_team).to eq(4)
        expect(match2.home_team).to eq(2)
        expect(match2.away_team).to eq(3)
      end

      it 'works for 5 teams' do
        driver = TestDriver.new(teams: [1, 2, 3, 4, 5])
        described_class.generate driver, round: 0

        expect(driver.created_matches.length).to eq(4)
        match1, match2, match3, match4 = driver.created_matches
        bies = [1, 2, 3]
        [match1, match3, match4].zip(bies).each do |match, team|
          expect(match.home_team).to eq(team)
          expect(match.away_team).to be nil
        end

        expect(match2.home_team).to eq(4)
        expect(match2.away_team).to eq(5)
      end

      it 'works for 6 teams' do
        driver = TestDriver.new(teams: [1, 2, 3, 4, 5, 6])
        described_class.generate driver, round: 0

        expect(driver.created_matches.length).to eq(4)
        match1, match2, match3, match4 = driver.created_matches
        expect(match1.home_team).to eq(1)
        expect(match1.away_team).to be nil
        expect(match2.home_team).to eq(4)
        expect(match2.away_team).to eq(5)
        expect(match3.home_team).to eq(2)
        expect(match3.away_team).to be nil
        expect(match4.home_team).to eq(3)
        expect(match4.away_team).to eq(6)
      end

      it 'works for 16 teams' do
        driver = TestDriver.new(teams: (1..16).to_a)
        described_class.generate driver, round: 0

        expect(driver.created_matches.length).to eq(8)
        matches = [
          [1, 16],
          [8, 9],
          [4, 13],
          [5, 12],
          [2, 15],
          [7, 10],
          [3, 14],
          [6, 11],
        ]
        driver.created_matches.zip(matches).each do |match, teams|
          expect(match.home_team).to eq(teams[0])
          expect(match.away_team).to eq(teams[1])
        end
      end
    end

    context 'full tournament' do
      it 'works for 4 teams' do
        winners = { [1, 4] => 1, [2, 3] => 3, [3, 1] => 3 }
        driver = TestDriver.new(teams: (1..4).to_a, winners: winners)

        (1..2).each do |round|
          described_class.generate driver, round: round
          driver.test_matches[round] = driver.created_matches.map do |match|
            [match.home_team, match.away_team]
          end
          driver.created_matches = []
        end

        expect(driver.matches.length).to eq(3)
      end
    end
  end

  describe '#guess_round' do
    it 'guesses right for 4 teams' do
      driver = TestDriver.new(teams: (1..4).to_a)
      guess = -> { described_class.guess_round(driver) }

      driver.test_matches = {}
      expect(guess.call).to eq(0)

      driver.test_matches = { 0 => (0...2).to_a }
      expect(guess.call).to eq(1)

      driver.test_matches = { 0 => (0...3).to_a }
      expect(guess.call).to eq(2)

      driver.test_matches = { 0 => (0...1).to_a }
      expect { guess.call }.to raise_error ArgumentError

      driver.test_matches = { 0 => (0...4).to_a }
      expect { guess.call }.to raise_error ArgumentError
    end

    it 'guesses right for 5 teams' do
      driver = TestDriver.new(teams: (1..5).to_a)
      guess = -> { described_class.guess_round(driver) }

      driver.test_matches = {}
      expect(guess.call).to eq(0)

      driver.test_matches = { 0 => (0...4).to_a }
      expect(guess.call).to eq(1)

      driver.test_matches = { 0 => (0...6).to_a }
      expect(guess.call).to eq(2)

      driver.test_matches = { 0 => (0...7).to_a }
      expect(guess.call).to eq(3)

      driver.test_matches = { 0 => (0...1).to_a }
      expect { guess.call }.to raise_error ArgumentError

      driver.test_matches = { 0 => (0...2).to_a }
      expect { guess.call }.to raise_error ArgumentError

      driver.test_matches = { 0 => (0...3).to_a }
      expect { guess.call }.to raise_error ArgumentError

      driver.test_matches = { 0 => (0...8).to_a }
      expect { guess.call }.to raise_error ArgumentError
    end

    it 'guesses right for 63 teams' do
      driver = TestDriver.new(teams: (1..64).to_a)
      guess = -> { described_class.guess_round(driver) }

      driver.test_matches = {}
      expect(guess.call).to eq(0)

      driver.test_matches = { 0 => (0...32).to_a }
      expect(guess.call).to eq(1)

      driver.test_matches = { 0 => (0...48).to_a }
      expect(guess.call).to eq(2)

      driver.test_matches = { 0 => (0...56).to_a }
      expect(guess.call).to eq(3)

      driver.test_matches = { 0 => (0...60).to_a }
      expect(guess.call).to eq(4)

      driver.test_matches = { 0 => (0...62).to_a }
      expect(guess.call).to eq(5)

      driver.test_matches = { 0 => (0...63).to_a }
      expect(guess.call).to eq(6)
    end
  end
end
