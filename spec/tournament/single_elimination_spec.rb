describe TournamentSystem::SingleElimination do
  describe '#total_rounds' do
    it 'calls Algorithm::SingleBracket#total_rounds' do
      driver = instance_double('Driver')
      expect(driver).to receive(:seeded_teams) { [1, 2] }

      expect(TournamentSystem::Algorithm::SingleBracket)
        .to receive(:total_rounds)
          .with(2) { 11 }

      expect(described_class.total_rounds(driver)).to eq(11)
    end
  end

  describe '#guess_round' do
    it 'calls Algorithm::SingleBracket#guess_round' do
      driver = instance_double('Driver')
      expect(driver).to receive(:seeded_teams) { [1, 2, 3, 4] }
      expect(driver).to receive(:matches) { [1, 2] }

      expect(TournamentSystem::Algorithm::SingleBracket)
        .to receive(:guess_round)
          .with(4, 2) { 11 }

      expect(described_class.guess_round(driver)).to eq(11)
    end
  end

  describe '#generate' do
    context 'first round' do
      it 'works for 4 teams' do
        driver = TestDriver.new(teams: [1, 2, 3, 4])

        matches = described_class.generate driver
        expect(driver.created_matches).to eq matches

        expect(matches.length).to eq(2)
        match1, match2 = matches
        expect(match1.home_team).to eq(1)
        expect(match1.away_team).to eq(4)
        expect(match2.home_team).to eq(2)
        expect(match2.away_team).to eq(3)
      end

      it 'works for 5 teams' do
        driver = TestDriver.new(teams: [1, 2, 3, 4, 5])

        matches = described_class.generate driver
        expect(driver.created_matches).to eq matches

        expect(matches.length).to eq(4)
        match1, match2, match3, match4 = matches
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

        matches = described_class.generate driver
        expect(driver.created_matches).to eq matches

        expect(matches.length).to eq(4)
        match1, match2, match3, match4 = matches
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

        matches = described_class.generate driver
        expect(driver.created_matches).to eq matches

        expect(matches.length).to eq(8)
        matched_teams = [
          [1, 16],
          [8, 9],
          [4, 13],
          [5, 12],
          [2, 15],
          [7, 10],
          [3, 14],
          [6, 11],
        ]
        matches.zip(matched_teams).each do |match, teams|
          expect(match.home_team).to eq(teams[0])
          expect(match.away_team).to eq(teams[1])
        end
      end
    end

    context 'full tournament' do
      it 'works for 4 teams' do
        winners = { [1, 4] => 1, [2, 3] => 3, [3, 1] => 3 }
        driver = TestDriver.new(teams: (1..4).to_a, winners: winners)

        2.times do
          described_class.generate driver
          driver.matches += driver.created_matches.map do |match|
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

      driver.matches = []
      expect(guess.call).to eq(0)

      driver.matches = (0...2).to_a
      expect(guess.call).to eq(1)

      driver.matches = (0...3).to_a
      expect(guess.call).to eq(2)

      driver.matches = (0...1).to_a
      expect { guess.call }.to raise_error ArgumentError

      driver.matches = (0...4).to_a
      expect { guess.call }.to raise_error ArgumentError
    end

    it 'guesses right for 5 teams' do
      driver = TestDriver.new(teams: (1..5).to_a)
      guess = -> { described_class.guess_round(driver) }

      driver.matches = []
      expect(guess.call).to eq(0)

      driver.matches = (0...4).to_a
      expect(guess.call).to eq(1)

      driver.matches = (0...6).to_a
      expect(guess.call).to eq(2)

      driver.matches = (0...7).to_a
      expect(guess.call).to eq(3)

      driver.matches = (0...1).to_a
      expect { guess.call }.to raise_error ArgumentError

      driver.matches = (0...2).to_a
      expect { guess.call }.to raise_error ArgumentError

      driver.matches = (0...3).to_a
      expect { guess.call }.to raise_error ArgumentError

      driver.matches = (0...8).to_a
      expect { guess.call }.to raise_error ArgumentError
    end

    it 'guesses right for 63 teams' do
      driver = TestDriver.new(teams: (1..64).to_a)
      guess = -> { described_class.guess_round(driver) }

      driver.matches = []
      expect(guess.call).to eq(0)

      driver.matches = (0...32).to_a
      expect(guess.call).to eq(1)

      driver.matches = (0...48).to_a
      expect(guess.call).to eq(2)

      driver.matches = (0...56).to_a
      expect(guess.call).to eq(3)

      driver.matches = (0...60).to_a
      expect(guess.call).to eq(4)

      driver.matches = (0...62).to_a
      expect(guess.call).to eq(5)

      driver.matches = (0...63).to_a
      expect(guess.call).to eq(6)
    end
  end
end
