require 'tournament/algorithm/util'

describe Tournament::Algorithm::Util do
  def gen_teams(num)
    (1..num).to_a.freeze
  end

  describe '#padd_teams' do
    it 'works for even teams' do
      expect(described_class.padd_teams(gen_teams(2))).to eq((1..2).to_a)
      expect(described_class.padd_teams(gen_teams(4))).to eq((1..4).to_a)
      expect(described_class.padd_teams(gen_teams(6))).to eq((1..6).to_a)
      expect(described_class.padd_teams(gen_teams(8))).to eq((1..8).to_a)
    end

    it 'works for odd teams' do
      expect(described_class.padd_teams(gen_teams(3)))
        .to eq((1..3).to_a + [nil])

      expect(described_class.padd_teams(gen_teams(5)))
        .to eq((1..5).to_a + [nil])

      expect(described_class.padd_teams(gen_teams(7)))
        .to eq((1..7).to_a + [nil])

      expect(described_class.padd_teams(gen_teams(9)))
        .to eq((1..9).to_a + [nil])
    end
  end

  describe '#padded_teams_count' do
    it 'works for even numbers' do
      expect(described_class.padded_teams_count(2)).to eq(2)
      expect(described_class.padded_teams_count(4)).to eq(4)
      expect(described_class.padded_teams_count(6)).to eq(6)
      expect(described_class.padded_teams_count(8)).to eq(8)
      expect(described_class.padded_teams_count(10)).to eq(10)
    end

    it 'works for odd numbers' do
      expect(described_class.padded_teams_count(3)).to eq(4)
      expect(described_class.padded_teams_count(5)).to eq(6)
      expect(described_class.padded_teams_count(7)).to eq(8)
      expect(described_class.padded_teams_count(9)).to eq(10)
      expect(described_class.padded_teams_count(11)).to eq(12)
    end
  end

  describe '#all_min_by' do
    it 'finds all minimum elements' do
      elements = [1, 2, 3, 4, 5, 6].freeze
      scores = { 1 => 1, 2 => 2, 3 => 3, 4 => 1, 5 => 2, 6 => 3 }.freeze

      result = described_class.all_min_by(elements) { |e| scores[e] }

      expect(result).to eq([1, 4])
    end
  end

  describe '#all_perfect_matches' do
    it 'works for 2 elements with size of 2' do
      result = described_class.all_perfect_matches(gen_teams(2), 2).to_a

      expect(result).to eq([[[1, 2]]])
    end

    it 'works for 4 elements with size of 2' do
      result = described_class.all_perfect_matches(gen_teams(4), 2).to_a

      expect(result).to eq(
        [
          [[1, 2], [3, 4]],
          [[1, 3], [2, 4]],
          [[1, 4], [2, 3]],
        ]
      )
    end

    it 'works for 6 elements with size of 2' do
      result = described_class.all_perfect_matches(gen_teams(6), 2).to_a

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

    pending 'works for other sizes' do
      result = described_class.all_perfect_matches(gen_teams(3), 1).to_a

      expect(result).to eq([[[1], [2], [3]]])

      # TODO: Uncomment and add more tests once working
      # result = described_class.all_perfect_matches([1, 2, 3], 3).to_a

      # expect(result).to eq([[[1, 2, 3]]])
    end
  end
end
