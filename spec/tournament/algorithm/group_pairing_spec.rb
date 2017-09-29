describe Tournament::Algorithm::GroupPairing do
  def gen_teams(num)
    (1..num).to_a.freeze
  end

  describe '#adjacent' do
    it 'pairs adjacent teams' do
      expect(described_class.adjacent(gen_teams(2))).to eq([[1, 2]])
      expect(described_class.adjacent(gen_teams(4))).to eq([[1, 2], [3, 4]])
      expect(described_class.adjacent(gen_teams(6))).to eq([[1, 2], [3, 4], [5, 6]])
      expect(described_class.adjacent(gen_teams(8))).to eq([[1, 2], [3, 4], [5, 6], [7, 8]])
    end
  end

  describe '#fold' do
    it 'pairs teams by matching best to worst' do
      expect(described_class.fold(gen_teams(2))).to eq([[1, 2]])
      expect(described_class.fold(gen_teams(4))).to eq([[1, 4], [2, 3]])
      expect(described_class.fold(gen_teams(6))).to eq([[1, 6], [2, 5], [3, 4]])
      expect(described_class.fold(gen_teams(8))).to eq([[1, 8], [2, 7], [3, 6], [4, 5]])
    end
  end

  describe '#slide' do
    it 'pairs teams by sliding the top half over the bottom' do
      expect(described_class.slide(gen_teams(2))).to eq([[1, 2]])
      expect(described_class.slide(gen_teams(4))).to eq([[1, 3], [2, 4]])
      expect(described_class.slide(gen_teams(6))).to eq([[1, 4], [2, 5], [3, 6]])
      expect(described_class.slide(gen_teams(8))).to eq([[1, 5], [2, 6], [3, 7], [4, 8]])
    end
  end

  describe '#random' do
    it 'pairs randomly' do
      teams = gen_teams(64)

      result = described_class.random(teams)

      teams.each do |team|
        expect(result.map { |pair| pair.count(team) }.reduce(:+)).to eq(1)
      end
    end

    it 'handles nil teams' do
      teams = [1, 2, 3, nil].freeze

      result = described_class.random(teams)

      teams.each do |team|
        expect(result.map { |pair| pair.count(team) }.reduce(:+)).to eq(1)
      end
    end
  end
end
