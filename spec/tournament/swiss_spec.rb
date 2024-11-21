describe TournamentSystem::Swiss do
  describe '#minimum_rounds' do
    it 'calls Algorithm::Swiss#minimum_rounds' do
      driver = instance_double('Driver')
      expect(driver).to receive(:seeded_teams) { [1, 2] }

      expect(TournamentSystem::Algorithm::Swiss)
        .to receive(:minimum_rounds)
          .with(2) { 11 }

      expect(described_class.minimum_rounds(driver)).to eq(11)
    end
  end

  describe '#generate' do
    it 'calls pairer and generates matches' do
      driver = TestDriver.new

      pairer = instance_double('Pairer')
      expect(pairer).to receive(:pair).with(driver, 3) { [[1, 2], [4, 3]] }

      matches = described_class.generate(driver, pairer: pairer, pair_options: 3)

      expect(matches.length).to eq 2
      match1, match2 = matches
      expect(match1.home_team).to eq(1)
      expect(match1.away_team).to eq(2)
      expect(match2.home_team).to eq(4)
      expect(match2.away_team).to eq(3)
    end
  end
end
