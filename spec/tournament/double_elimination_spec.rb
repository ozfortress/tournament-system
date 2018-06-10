describe TournamentSystem::DoubleElimination do
  def gen_matches(num)
    Array.new(num) { [0, 1] }
  end

  describe '#total_rounds' do
    it 'calls Algorithm::DoubleBracket#total_rounds' do
      driver = instance_double('Driver')
      expect(driver).to receive(:seeded_teams) { [1, 2] }

      expect(TournamentSystem::Algorithm::DoubleBracket)
        .to receive(:total_rounds)
          .with(2) { 11 }

      expect(described_class.total_rounds(driver)).to eq(11)
    end
  end

  describe '#guess_round' do
    it 'calls Algorithm::DoubleBracket#guess_round' do
      driver = instance_double('Driver')
      expect(driver).to receive(:seeded_teams) { [1, 2, 3, 4] }
      expect(driver).to receive(:non_bye_matches) { [1, 2] }

      expect(TournamentSystem::Algorithm::DoubleBracket)
        .to receive(:guess_round)
          .with(4, 2) { 11 }

      expect(described_class.guess_round(driver)).to eq(11)
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
        described_class.generate driver

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
        described_class.generate driver

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
        winners = { [1, 4] => 1, [2, 3] => 3, [1, 3] => 3, [4, 2] => 2, [1, 2] => 1 }
        matches = []
        matches_by_round = {}

        4.times do |round|
          driver = TestDriver.new(teams: (1..4).to_a, winners: winners, matches: matches)
          described_class.generate driver

          round_matches = driver.created_matches.map do |match|
            [match.home_team, match.away_team]
          end
          matches += round_matches
          matches_by_round[round] = round_matches
        end

        expect(matches.length).to eq(6)
        expect(matches_by_round.length).to eq(4)

        round0 = matches_by_round[0]
        expect(round0.length).to eq(2)
        expect(round0[0]).to eq([1, 4])
        expect(round0[1]).to eq([2, 3])

        round1 = matches_by_round[1]
        expect(round1.length).to eq(2)
        expect(round1[0]).to eq([1, 3])
        expect(round1[1]).to eq([4, 2])

        round2 = matches_by_round[2]
        expect(round2.length).to eq(1)
        expect(round2[0]).to eq([1, 2])

        round3 = matches_by_round[3]
        expect(round3.length).to eq(1)
        expect(round3[0]).to eq([3, 1])
      end

      it 'works for 5 teams' do
        winners = { [4, 5] => 4, [1, 4] => 1, [2, 3] => 3, [1, 3] => 1, [4, 2] => 2 }
        matches = []
        matches_by_round = {}

        6.times do |round|
          driver = TestDriver.new(teams: (1..5).to_a, winners: winners, matches: matches)
          described_class.generate driver

          round_matches = driver.created_matches.map do |match|
            [match.home_team, match.away_team]
          end
          matches += round_matches
          matches_by_round[round] = round_matches
        end

        expect(matches_by_round).to eq(
          0 => [[1, nil], [4, 5], [2, nil], [3, nil]],
          1 => [[1, 4], [2, 3], [5, nil]],
          2 => [[4, 5], [2, nil]],
          3 => [[1, 3], [4, 2]],
          4 => [[2, 3]],
          5 => [[1, 3]]
        )
      end

      it 'works for 8 teams' do
        # rubocop:disable Lint/DuplicatedKey
        winners = {
          [1, 8] => 1, [4, 5] => 5, [2, 7] => 2, [3, 6] => 3,
          [1, 5] => 1, [2, 3] => 3, [8, 4] => 4, [7, 6] => 6,
          [4, 5] => 5, [2, 6] => 2,
          [1, 3] => 1, [5, 2] => 2,
        }
        # rubocop:enable Lint/DuplicatedKey
        matches = []
        matches_by_round = {}

        6.times do |round|
          driver = TestDriver.new(teams: (1..8).to_a, winners: winners, matches: matches)
          described_class.generate driver

          round_matches = driver.created_matches.map do |match|
            [match.home_team, match.away_team]
          end
          matches += round_matches
          matches_by_round[round] = round_matches
        end

        expect(matches.length).to eq(14)

        expect(matches_by_round).to eq(
          0 => [[1, 8], [4, 5], [2, 7], [3, 6]],
          1 => [[1, 5], [2, 3], [8, 4], [7, 6]],
          2 => [[4, 5], [2, 6]],
          3 => [[1, 3], [5, 2]],
          4 => [[2, 3]],
          5 => [[1, 3]]
        )
      end
    end
  end

  describe '#guess_round' do
    it 'guesses right for 4 teams' do
      driver = TestDriver.new(teams: (1..4).to_a)
      guess = -> { described_class.guess_round(driver) }

      driver.matches = []
      expect(guess.call).to eq(0)

      driver.matches = gen_matches(2)
      expect(guess.call).to eq(1)

      driver.matches = gen_matches(4)
      expect(guess.call).to eq(2)

      driver.matches = gen_matches(5)
      expect(guess.call).to eq(3)

      driver.matches = gen_matches(1)
      expect { guess.call }.to raise_error ArgumentError

      driver.matches = gen_matches(3)
      expect { guess.call }.to raise_error ArgumentError

      driver.matches = gen_matches(6)
      expect { guess.call }.to raise_error ArgumentError
    end

    it 'guesses right for 5 teams' do
      driver = TestDriver.new(teams: (1..5).to_a)
      guess = -> { described_class.guess_round(driver) }

      driver.matches = []
      expect(guess.call).to eq(0)

      driver.matches = gen_matches(1)
      expect(guess.call).to eq(1)

      driver.matches = gen_matches(3)
      expect(guess.call).to eq(2)

      driver.matches = gen_matches(4)
      expect(guess.call).to eq(3)

      driver.matches = gen_matches(6)
      expect(guess.call).to eq(4)

      driver.matches = gen_matches(7)
      expect(guess.call).to eq(5)

      driver.matches = gen_matches(2)
      expect { guess.call }.to raise_error ArgumentError

      driver.matches = gen_matches(5)
      expect { guess.call }.to raise_error ArgumentError

      driver.matches = gen_matches(8)
      expect { guess.call }.to raise_error ArgumentError
    end
  end
end
