require 'tournament/algorithm/pairers/best_min_duplicates'

describe Tournament::Algorithm::Pairers::BestMinDuplicates do
  describe '#pair' do
    it 'pairs with minimal duplicates' do
      teams = [1, 2, 3, 4]
      matches = [[1, 3], [2, 4], [1, 4], [3, 2]]
      matches_counts = matches.map { |m| [Set.new(m), 1] }.to_h
      points = { 1 => 32, 2 => 16, 3 => 8, 4 => 0 }

      pairs = described_class.pair(teams, points, matches_counts)
      expect(pairs).to eq([[1, 2], [3, 4]])
    end

    it 'pairs with minimal point difference' do
      teams = [1, 2, 3, 4]
      matches = [[1, 2], [3, 4], [1, 3], [2, 4], [1, 4], [3, 2]]
      matches_counts = matches.map { |m| [Set.new(m), 1] }.to_h
      points = { 1 => 15, 2 => 12, 3 => 14, 4 => 11 }

      pairs = described_class.pair(teams, points, matches_counts)
      expect(pairs).to eq([[1, 3], [2, 4]])
    end
  end
end
