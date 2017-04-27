describe Tournament::Seeder::SingleBracket do
  describe '#seed' do
    it 'seeds 4 teams' do
      teams = [1, 2, 3, 4]
      teams = described_class.seed(teams)

      expect(teams).to eq([1, 4, 2, 3])
    end

    it 'seeds 8 teams' do
      teams = [1, 2, 3, 4, 5, 6, 7, 8]
      teams = described_class.seed(teams)

      expect(teams).to eq([1, 8, 4, 5, 2, 7, 3, 6])
    end

    it 'seeds 16 teams' do
      teams = (1..16).to_a
      teams = described_class.seed(teams)

      expect(teams).to eq([1, 16, 8, 9, 4, 13, 5, 12,
                           2, 15, 7, 10, 3, 14, 6, 11])
    end

    it 'seeds 32 teams' do
      teams = (1..32).to_a
      teams = described_class.seed(teams)

      expect(teams).to eq(
        [
          1, 32, 16, 17, 8, 25, 9, 24, 4, 29, 13, 20, 5, 28, 12, 21,
          2, 31, 15, 18, 7, 26, 10, 23, 3, 30, 14, 19, 6, 27, 11, 22
        ]
      )
    end

    it 'handles bye teams' do
      teams = [1, 2, 3, 4, 5, 6, nil, nil]
      teams = described_class.seed(teams)
      expect(teams).to eq([1, nil, 4, 5, 2, nil, 3, 6])

      teams = [nil, nil, 3, 4, 5, 6, 7, 8]
      teams = described_class.seed(teams)
      expect(teams).to eq([nil, 8, 4, 5, nil, 7, 3, 6])
    end

    it 'fails for non-power of 2 teams' do
      expect { described_class.seed((1..3).to_a) }.to raise_error ArgumentError
      expect { described_class.seed((1..5).to_a) }.to raise_error ArgumentError
      expect { described_class.seed((1..6).to_a) }.to raise_error ArgumentError
    end
  end
end
