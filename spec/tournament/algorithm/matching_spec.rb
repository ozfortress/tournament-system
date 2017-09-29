describe Tournament::Algorithm::Matching do
  def gen_teams(num)
    (1..num).to_a.freeze
  end

  describe '#all_perfect_matchings' do
    it 'works for 2 elements' do
      result = described_class.all_perfect_matchings(gen_teams(2)).to_a

      expect(result).to eq([[[1, 2]]])
    end

    it 'works for 4 elements' do
      result = described_class.all_perfect_matchings(gen_teams(4)).to_a

      expect(result).to eq(
        [
          [[1, 2], [3, 4]],
          [[1, 3], [2, 4]],
          [[1, 4], [2, 3]],
        ]
      )
    end

    it 'works for 6 elements' do
      result = described_class.all_perfect_matchings(gen_teams(6)).to_a

      expect(result).to eq(
        [
          [[1, 2], [3, 4], [5, 6]],
          [[1, 2], [3, 5], [4, 6]],
          [[1, 2], [3, 6], [4, 5]],
          [[1, 3], [2, 4], [5, 6]],
          [[1, 3], [2, 5], [4, 6]],
          [[1, 3], [2, 6], [4, 5]],
          [[1, 4], [2, 3], [5, 6]],
          [[1, 4], [2, 5], [3, 6]],
          [[1, 4], [2, 6], [3, 5]],
          [[1, 5], [2, 3], [4, 6]],
          [[1, 5], [2, 4], [3, 6]],
          [[1, 5], [2, 6], [3, 4]],
          [[1, 6], [2, 3], [4, 5]],
          [[1, 6], [2, 4], [3, 5]],
          [[1, 6], [2, 5], [3, 4]],
        ]
      )
    end
  end

  describe '#maximum_weight_perfect_matching' do
    it 'works for 2 elements' do
      teams = gen_teams(2)
      weights = {
        Set[1, 2] => 1,
      }

      expect(described_class.maximum_weight_perfect_matching(teams) do |team1, team2|
        weights[Set[team1, team2]]
      end).to eq([[2, 1]])
    end

    it 'works for 4 elements' do
      teams = gen_teams(4)
      weights = {
        Set[1, 2] => 0,
        Set[1, 3] => 1,
        Set[1, 4] => 2,
        Set[2, 3] => 1,
        Set[2, 4] => 2,
        Set[3, 4] => -1,
      }

      expect(described_class.maximum_weight_perfect_matching(teams) do |team1, team2|
        weights[Set[team1, team2]]
      end).to eq([[3, 1], [4, 2]])
    end

    it 'handles nil values' do
      teams = [1, 2, 3, nil].freeze
      weights = {
        Set[1, 2]   => 0,
        Set[1, 3]   => 1,
        Set[1, nil] => 2,
        Set[2, 3]   => 1,
        Set[2, nil] => 2,
        Set[3, nil] => -1,
      }

      expect(described_class.maximum_weight_perfect_matching(teams) do |team1, team2|
        weights[Set[team1, team2]]
      end).to eq([[3, 1], [nil, 2]])
    end
  end
end
