require 'tournament_system/algorithm/util'

describe TournamentSystem::Algorithm::Util do
  def gen_teams(num)
    (1..num).to_a.freeze
  end

  describe '#padd_teams_even' do
    it 'works for even teams' do
      expect(described_class.padd_teams_even(gen_teams(2))).to eq((1..2).to_a)
      expect(described_class.padd_teams_even(gen_teams(4))).to eq((1..4).to_a)
      expect(described_class.padd_teams_even(gen_teams(6))).to eq((1..6).to_a)
      expect(described_class.padd_teams_even(gen_teams(8))).to eq((1..8).to_a)
    end

    it 'works for odd teams' do
      expect(described_class.padd_teams_even(gen_teams(3)))
        .to eq((1..3).to_a + [nil])

      expect(described_class.padd_teams_even(gen_teams(5)))
        .to eq((1..5).to_a + [nil])

      expect(described_class.padd_teams_even(gen_teams(7)))
        .to eq((1..7).to_a + [nil])

      expect(described_class.padd_teams_even(gen_teams(9)))
        .to eq((1..9).to_a + [nil])
    end
  end

  describe '#padd_teams_pow2' do
    it 'works' do
      expect(described_class.padd_teams_pow2(gen_teams(2))).to eq([1, 2])
      expect(described_class.padd_teams_pow2(gen_teams(3))).to eq([1, 2, 3, nil])
      expect(described_class.padd_teams_pow2(gen_teams(4))).to eq([1, 2, 3, 4])
      expect(described_class.padd_teams_pow2(gen_teams(5)))
        .to eq([1, 2, 3, 4, 5, nil, nil, nil])
      expect(described_class.padd_teams_pow2(gen_teams(6)))
        .to eq([1, 2, 3, 4, 5, 6, nil, nil])
      expect(described_class.padd_teams_pow2(gen_teams(7)))
        .to eq([1, 2, 3, 4, 5, 6, 7, nil])
      expect(described_class.padd_teams_pow2(gen_teams(8)))
        .to eq([1, 2, 3, 4, 5, 6, 7, 8])
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
end
