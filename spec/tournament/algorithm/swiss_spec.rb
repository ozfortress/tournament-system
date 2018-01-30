require 'tournament_system/algorithm/swiss'

describe TournamentSystem::Algorithm::Swiss do
  describe '#minimum_rounds' do
    it 'works' do
      expect(described_class.minimum_rounds(2)).to eq(1)
      expect(described_class.minimum_rounds(3)).to eq(2)
      expect(described_class.minimum_rounds(4)).to eq(2)
      expect(described_class.minimum_rounds(9)).to eq(4)
    end
  end

  describe '#group_teams_by_score' do
    it 'handles all scores being identical' do
      scores = Hash.new(0)

      groups = described_class.group_teams_by_score([1].freeze, scores)
      expect(groups).to eq([[1]])

      groups = described_class.group_teams_by_score([1, 2].freeze, scores)
      expect(groups).to eq([[1, 2]])

      groups = described_class.group_teams_by_score([1, 2, 3].freeze, scores)
      expect(groups).to eq([[1, 2, 3]])

      groups = described_class.group_teams_by_score([1, 2, 3, 4].freeze,
                                                    scores)
      expect(groups).to eq([[1, 2, 3, 4]])

      groups = described_class.group_teams_by_score([1, 2, 3, 4, 5].freeze,
                                                    scores)
      expect(groups).to eq([[1, 2, 3, 4, 5]])

      groups = described_class.group_teams_by_score([1, 2, 3, 4, 5, 6].freeze,
                                                    scores)
      expect(groups).to eq([[1, 2, 3, 4, 5, 6]])
    end

    it 'handles all scores being unique' do
      scores = { 1 => 6, 2 => 5, 3 => 4, 4 => 3, 5 => 2, 6 => 1 }.freeze

      groups = described_class.group_teams_by_score([1].freeze, scores)
      expect(groups).to eq([[1]])

      groups = described_class.group_teams_by_score([1, 2].freeze, scores)
      expect(groups).to eq([[1], [2]])

      groups = described_class.group_teams_by_score([1, 2, 3].freeze, scores)
      expect(groups).to eq([[1], [2], [3]])

      groups = described_class.group_teams_by_score([1, 2, 3, 4].freeze, scores)
      expect(groups).to eq([[1], [2], [3], [4]])
    end

    it 'handles nil players' do
      scores = { 1 => 4, 2 => 4, 3 => 2 }
      groups = described_class.group_teams_by_score([1, 2, 3, nil].freeze,
                                                    scores.freeze)
      expect(groups).to eq([[1, 2], [3], [nil]])
    end

    it 'sorts group by score' do
      scores = { 1 => 6, 2 => 6, 3 => 4, 4 => 8, 5 => 4, 6 => 2 }
      groups = described_class.group_teams_by_score([1, 2, 3, 4, 5, 6].freeze,
                                                    scores.freeze)
      expect(groups).to eq([[4], [1, 2], [3, 5], [6]])
    end
  end

  describe '#rollover_groups' do
    it 'works for many odd groups' do
      groups = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [10, 11, 12]]

      described_class.rollover_groups(groups)

      expect(groups).to eq([[1, 2], [3, 4, 5, 6], [7, 8], [9, 10, 11, 12]])
    end

    it 'works for alternating odd-even' do
      groups = [[1, 2, 3], [4, 5], [6, 7, 8], [9, 10]]

      described_class.rollover_groups(groups)

      expect(groups).to eq([[1, 2], [3, 4], [5, 6, 7, 8], [9, 10]])
    end

    it 'works for odd even* odd' do
      groups = [[1, 2, 3], [4, 5], [6, 7], [8, 9], [10, 11, 12]]

      described_class.rollover_groups(groups)

      expect(groups).to eq([[1, 2], [3, 4], [5, 6], [7, 8], [9, 10, 11, 12]])
    end

    it 'works for groups with one player' do
      groups = [[1], [2], [3], [4]]

      described_class.rollover_groups(groups)

      expect(groups).to eq([[1, 2], [3, 4]])
    end
  end
end
