describe TournamentSystem::PagePlayoff do
  describe '#total_rounds' do
    it 'returns 3' do
      expect(described_class.total_rounds).to eq(3)
    end
  end

  describe '#guess_round' do
    it 'calls Algorithm::PagePlayoff#guess_round' do
      driver = instance_double('Driver')
      expect(driver).to receive(:matches) { [1, 2] }

      expect(TournamentSystem::Algorithm::PagePlayoff)
        .to receive(:guess_round)
          .with(2) { 11 }

      expect(described_class.guess_round(driver)).to eq(11)
    end
  end

  describe '#generate' do
    let(:teams) { [1, 2, 3, 4] }

    it 'handles invalid round option' do
      driver = TestDriver.new(teams: teams)
      expect { described_class.generate driver, round: 3 }
        .to raise_exception Exception
    end

    it 'handles invalid number of teams' do
      driver = TestDriver.new(teams: [1, 2, 3])
      expect { described_class.generate driver }.to raise_exception Exception

      driver = TestDriver.new(teams: [1, 2, 3, 4, 5])
      expect { described_class.generate driver }.to raise_exception Exception
    end

    context 'semi-finals' do
      it 'works' do
        driver = TestDriver.new(teams: teams)

        matches = described_class.generate driver
        expect(driver.created_matches).to eq matches

        expect(matches.length).to eq(2)
        match1, match2 = matches
        expect(match1.home_team).to eq(1)
        expect(match1.away_team).to eq(2)
        expect(match2.home_team).to eq(3)
        expect(match2.away_team).to eq(4)
      end
    end

    context 'semi-finals' do
      let(:matches) { [[1, 2], [3, 4]] }

      it 'works' do
        winners = { [1, 2] => 2, [3, 4] => 4 }
        driver = TestDriver.new(teams: teams, winners: winners,
                                matches: matches)
        matches = described_class.generate driver
        expect(driver.created_matches).to eq matches

        expect(matches.length).to eq(1)
        match = matches.first
        expect(match.home_team).to eq(1)
        expect(match.away_team).to eq(4)
      end
    end

    context 'grand-finals' do
      let(:matches) { [[1, 2], [3, 4], [1, 4]] }

      it 'generates grand final match' do
        winners = { [1, 2] => 2, [3, 4] => 4, [1, 4] => 1 }
        driver = TestDriver.new(teams: teams, winners: winners,
                                matches: matches)
        matches = described_class.generate driver
        expect(driver.created_matches).to eq matches

        expect(matches.length).to eq(1)
        match = matches.first
        expect(match.home_team).to eq(2)
        expect(match.away_team).to eq(1)
      end

      it 'generates bronze match' do
        winners = { [1, 2] => 2, [3, 4] => 4, [1, 4] => 1 }
        driver = TestDriver.new(teams: teams, winners: winners,
                                matches: matches)
        matches = described_class.generate driver, bronze_match: true
        expect(driver.created_matches).to eq matches

        expect(matches.length).to eq(2)
        match1, match2 = matches
        expect(match1.home_team).to eq(2)
        expect(match1.away_team).to eq(1)
        expect(match2.home_team).to eq(4)
        expect(match2.away_team).to eq(3)
      end
    end
  end
end
