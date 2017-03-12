describe Tournament::PagePlayoff do
  describe '#total_rounds' do
    it 'returns 3' do
      expect(described_class.total_rounds).to eq(3)
    end
  end

  describe '#guess_round' do
    it 'works for valid input' do
      driver = TestDriver.new
      expect(described_class.guess_round(driver)).to eq(0)

      driver.test_matches[0] = [[1, 2], [3, 4]]
      expect(described_class.guess_round(driver)).to eq(1)

      driver.test_matches[0] = [[1, 2], [3, 4], [2, 3]]
      expect(described_class.guess_round(driver)).to eq(2)
    end

    it 'handles invalid input' do
      driver = TestDriver.new
      driver.test_matches[0] = [[1, 2]]
      expect { described_class.guess_round(driver) }
        .to raise_exception Exception

      driver.test_matches[0] = [[1, 2], [3, 4], [2, 3], [1, 2]]
      expect { described_class.guess_round(driver) }
        .to raise_exception Exception

      driver.test_matches[0] = [[1, 2], [3, 4], [2, 3], [1, 2], [3, 4]]
      expect { described_class.guess_round(driver) }
        .to raise_exception Exception
    end
  end

  describe '#generate' do
    let(:teams) { [1, 2, 3, 4] }

    context 'semi-finals' do
      it 'works' do
        driver = TestDriver.new(teams: teams)
        described_class.generate driver

        expect(driver.created_matches.length).to eq(2)
        match1, match2 = driver.created_matches
        expect(match1.home_team).to eq(1)
        expect(match1.away_team).to eq(2)
        expect(match2.home_team).to eq(3)
        expect(match2.away_team).to eq(4)
      end
    end

    context 'semi-finals' do
      let(:matches) { { 0 => [[1, 2], [3, 4]] } }

      it 'works' do
        winners = { [1, 2] => 2, [3, 4] => 4 }
        driver = TestDriver.new(teams: teams, winners: winners,
                                matches: matches)
        described_class.generate driver

        expect(driver.created_matches.length).to eq(1)
        match = driver.created_matches.first
        expect(match.home_team).to eq(1)
        expect(match.away_team).to eq(4)
      end
    end

    context 'grand-finals' do
      let(:matches) { { 0 => [[1, 2], [3, 4]], 1 => [[1, 4]] } }

      it 'generates grand final match' do
        winners = { [1, 2] => 2, [3, 4] => 4, [1, 4] => 1 }
        driver = TestDriver.new(teams: teams, winners: winners,
                                matches: matches)
        described_class.generate driver

        expect(driver.created_matches.length).to eq(1)
        match = driver.created_matches.first
        expect(match.home_team).to eq(2)
        expect(match.away_team).to eq(1)
      end

      it 'generates bronze match' do
        winners = { [1, 2] => 2, [3, 4] => 4, [1, 4] => 4 }
        driver = TestDriver.new(teams: teams, winners: winners,
                                matches: matches)
        described_class.generate driver, bronze_match: true

        expect(driver.created_matches.length).to eq(2)
        match1, match2 = driver.created_matches
        expect(match1.home_team).to eq(2)
        expect(match1.away_team).to eq(4)
        expect(match2.home_team).to eq(1)
        expect(match2.away_team).to eq(3)
      end
    end
  end
end
