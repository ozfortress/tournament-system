describe TournamentSystem::Algorithm::SingleBracket do
  def gen_teams(num)
    (1..num).to_a.freeze
  end

  describe '#total_rounds' do
    it 'works for powers of 2' do
      expect(described_class.total_rounds(2)).to eq(1)
      expect(described_class.total_rounds(4)).to eq(2)
      expect(described_class.total_rounds(8)).to eq(3)
      expect(described_class.total_rounds(16)).to eq(4)
      expect(described_class.total_rounds(32)).to eq(5)
      expect(described_class.total_rounds(64)).to eq(6)
    end

    it 'handles non-powers of 2' do
      expect(described_class.total_rounds(3)).to eq(2)
      expect(described_class.total_rounds(5)).to eq(3)
      expect(described_class.total_rounds(6)).to eq(3)
      expect(described_class.total_rounds(7)).to eq(3)
      expect(described_class.total_rounds(9)).to eq(4)
      expect(described_class.total_rounds(10)).to eq(4)
    end
  end

  describe '#max_teams' do
    it 'works for valid input' do
      expect(described_class.max_teams(1)).to eq(2)
      expect(described_class.max_teams(2)).to eq(4)
      expect(described_class.max_teams(3)).to eq(8)
      expect(described_class.max_teams(4)).to eq(16)
      expect(described_class.max_teams(5)).to eq(32)
    end
  end

  describe '#guess_round' do
    it 'works for 4 teams' do
      expect(described_class.guess_round(4, 0)).to eq(0)
      expect(described_class.guess_round(4, 2)).to eq(1)
      expect(described_class.guess_round(4, 3)).to eq(2)
    end

    it 'works for 6 teams' do
      expect(described_class.guess_round(6, 0)).to eq(0)
      expect(described_class.guess_round(6, 4)).to eq(1)
      expect(described_class.guess_round(6, 6)).to eq(2)
      expect(described_class.guess_round(6, 7)).to eq(3)
    end

    it 'handles invalid matches' do
      expect { described_class.guess_round(4, 1) }.to raise_error ArgumentError
      expect { described_class.guess_round(8, 5) }.to raise_error ArgumentError
      expect { described_class.guess_round(2, 2) }.to raise_error ArgumentError
      expect { described_class.guess_round(2, 3) }.to raise_error ArgumentError
    end
  end

  describe '#padd_teams' do
    it 'works' do
      expect(described_class.padd_teams(gen_teams(2))).to eq([1, 2])
      expect(described_class.padd_teams(gen_teams(3))).to eq([1, 2, 3, nil])
      expect(described_class.padd_teams(gen_teams(4))).to eq([1, 2, 3, 4])
      expect(described_class.padd_teams(gen_teams(5)))
        .to eq([1, 2, 3, 4, 5, nil, nil, nil])
      expect(described_class.padd_teams(gen_teams(6)))
        .to eq([1, 2, 3, 4, 5, 6, nil, nil])
      expect(described_class.padd_teams(gen_teams(7)))
        .to eq([1, 2, 3, 4, 5, 6, 7, nil])
      expect(described_class.padd_teams(gen_teams(8)))
        .to eq([1, 2, 3, 4, 5, 6, 7, 8])
    end
  end

  describe '#seed' do
    it 'works for powers of 2' do
      expect(described_class.seed(gen_teams(2))).to eq([1, 2])
      expect(described_class.seed(gen_teams(4))).to eq([1, 4, 2, 3])
      expect(described_class.seed(gen_teams(8)))
        .to eq([1, 8, 4, 5, 2, 7, 3, 6])
      expect(described_class.seed(gen_teams(16)))
        .to eq([1, 16, 8, 9, 4, 13, 5, 12, 2, 15, 7, 10, 3, 14, 6, 11])
      expect(described_class.seed(gen_teams(32))).to eq(
        [
          1, 32, 16, 17, 8, 25, 9, 24, 4, 29, 13, 20, 5, 28, 12, 21,
          2, 31, 15, 18, 7, 26, 10, 23, 3, 30, 14, 19, 6, 27, 11, 22
        ]
      )
    end

    it 'handles byes' do
      teams = [1, 2, 3, 4, 5, 6, nil, nil].freeze
      result = described_class.seed(teams)
      expect(result).to eq([1, nil, 4, 5, 2, nil, 3, 6])
    end

    it 'fails for non-power of 2 teams' do
      expect { described_class.seed(gen_teams(3)) }.to raise_error ArgumentError
      expect { described_class.seed(gen_teams(5)) }.to raise_error ArgumentError
      expect { described_class.seed(gen_teams(6)) }.to raise_error ArgumentError
    end
  end
end
