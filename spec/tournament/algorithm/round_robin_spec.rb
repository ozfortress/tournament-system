describe Tournament::Algorithm::RoundRobin do
  describe '#total_rounds' do
    it 'works for valid input' do
      expect(described_class.total_rounds(3)).to eq(3)
      expect(described_class.total_rounds(2)).to eq(1)
      expect(described_class.total_rounds(6)).to eq(5)
      expect(described_class.total_rounds(9)).to eq(9)
    end
  end

  describe '#guess_round' do
    it 'works for 4 teams' do
      expect(described_class.guess_round(4, 0)).to eq(0)
      expect(described_class.guess_round(4, 2)).to eq(1)
      expect(described_class.guess_round(4, 4)).to eq(2)
      expect(described_class.guess_round(4, 6)).to eq(3)
      expect(described_class.guess_round(4, 8)).to eq(4)
    end
  end

  describe '#round_robin' do
    it 'works for 4 teams' do
      teams = [1, 2, 3, 4]

      expect(described_class.round_robin(teams, 0)).to eq([1, 2, 3, 4])
      expect(described_class.round_robin(teams, 1)).to eq([1, 4, 2, 3])
      expect(described_class.round_robin(teams, 2)).to eq([1, 3, 4, 2])
      expect(described_class.round_robin(teams, 3)).to eq([1, 2, 3, 4])
      expect(described_class.round_robin(teams, 4)).to eq([1, 4, 2, 3])
    end
  end

  describe '#round_robin_enum' do
    it 'works for 4 teams' do
      teams = [1, 2, 3, 4]

      matches = described_class.round_robin_enum(teams).to_a
      expect(matches).to eq([[1, 2, 3, 4], [1, 4, 2, 3], [1, 3, 4, 2]])
    end
  end

  describe '#round_robin_pairing' do
    it 'works for 4 teams' do
      teams = [1, 2, 3, 4]

      matches = described_class.round_robin_pairing(teams, 0)
      expect(matches).to eq([[1, 4], [2, 3]])
      matches = described_class.round_robin_pairing(teams, 1)
      expect(matches).to eq([[1, 3], [4, 2]])
      matches = described_class.round_robin_pairing(teams, 2)
      expect(matches).to eq([[1, 2], [3, 4]])
    end
  end
end
