describe TournamentSystem::Algorithm::DoubleBracket do
  describe '#total_rounds' do
    it 'works' do
      expect(described_class.total_rounds(3)).to eq(4)
      expect(described_class.total_rounds(4)).to eq(4)
      expect(described_class.total_rounds(5)).to eq(6)
      expect(described_class.total_rounds(6)).to eq(6)
      expect(described_class.total_rounds(7)).to eq(6)
      expect(described_class.total_rounds(8)).to eq(6)
      expect(described_class.total_rounds(9)).to eq(8)
      expect(described_class.total_rounds(10)).to eq(8)
      expect(described_class.total_rounds(15)).to eq(8)
      expect(described_class.total_rounds(16)).to eq(8)
      expect(described_class.total_rounds(17)).to eq(10)
      expect(described_class.total_rounds(32)).to eq(10)
      expect(described_class.total_rounds(64)).to eq(12)
    end
  end

  describe '#max_teams' do
    it 'works' do
      expect(described_class.max_teams(5)).to eq(4)
      expect(described_class.max_teams(7)).to eq(8)
      expect(described_class.max_teams(9)).to eq(16)
      expect(described_class.max_teams(11)).to eq(32)
      expect(described_class.max_teams(13)).to eq(64)
      expect(described_class.max_teams(15)).to eq(128)
      expect(described_class.max_teams(17)).to eq(256)
    end
  end

  describe '#guess_round' do
    it 'handles invalid number of matches' do
      expect { described_class.guess_round(2, -1) }.to raise_error(ArgumentError)
      expect { described_class.guess_round(2, 2) }.to raise_error(ArgumentError)
      expect { described_class.guess_round(2, 3) }.to raise_error(ArgumentError)
      expect { described_class.guess_round(2, 4) }.to raise_error(ArgumentError)
      expect { described_class.guess_round(8, 3) }.to raise_error(ArgumentError)
      expect { described_class.guess_round(8, 5) }.to raise_error(ArgumentError)
      expect { described_class.guess_round(8, 7) }.to raise_error(ArgumentError)
      expect { described_class.guess_round(8, 11) }.to raise_error(ArgumentError)
      expect { described_class.guess_round(29, 56) }.to raise_error(ArgumentError)
    end

    it 'correctly guesses the round number' do
      expect(described_class.guess_round(2, 0)).to eq(0)
      expect(described_class.guess_round(2, 1)).to eq(1)
      expect(described_class.guess_round(4, 0)).to eq(0)
      expect(described_class.guess_round(4, 2)).to eq(1)
      expect(described_class.guess_round(4, 4)).to eq(2)
      expect(described_class.guess_round(4, 5)).to eq(3)
      expect(described_class.guess_round(5, 0)).to eq(0)
      expect(described_class.guess_round(5, 1)).to eq(1)
      expect(described_class.guess_round(5, 3)).to eq(2)
      expect(described_class.guess_round(5, 4)).to eq(3)
      expect(described_class.guess_round(5, 6)).to eq(4)
      expect(described_class.guess_round(5, 7)).to eq(5)
      expect(described_class.guess_round(6, 0)).to eq(0)
      expect(described_class.guess_round(6, 2)).to eq(1)
      expect(described_class.guess_round(6, 5)).to eq(2)
      expect(described_class.guess_round(6, 6)).to eq(3)
      expect(described_class.guess_round(6, 8)).to eq(4)
      expect(described_class.guess_round(6, 9)).to eq(5)
      expect(described_class.guess_round(7, 0)).to eq(0)
      expect(described_class.guess_round(7, 3)).to eq(1)
      expect(described_class.guess_round(7, 6)).to eq(2)
      expect(described_class.guess_round(7, 8)).to eq(3)
      expect(described_class.guess_round(7, 10)).to eq(4)
      expect(described_class.guess_round(7, 11)).to eq(5)
      expect(described_class.guess_round(8, 0)).to eq(0)
      expect(described_class.guess_round(8, 4)).to eq(1)
      expect(described_class.guess_round(8, 8)).to eq(2)
      expect(described_class.guess_round(8, 10)).to eq(3)
      expect(described_class.guess_round(8, 12)).to eq(4)
      expect(described_class.guess_round(8, 13)).to eq(5)
      expect(described_class.guess_round(16, 0)).to eq(0)
      expect(described_class.guess_round(16, 8)).to eq(1)
      expect(described_class.guess_round(16, 16)).to eq(2)
      expect(described_class.guess_round(16, 20)).to eq(3)
      expect(described_class.guess_round(16, 24)).to eq(4)
      expect(described_class.guess_round(16, 26)).to eq(5)
      expect(described_class.guess_round(16, 28)).to eq(6)
      expect(described_class.guess_round(16, 29)).to eq(7)
      expect(described_class.guess_round(29, 0)).to eq(0)
      expect(described_class.guess_round(29, 13)).to eq(1)
      expect(described_class.guess_round(29, 27)).to eq(2)
      expect(described_class.guess_round(29, 34)).to eq(3)
      expect(described_class.guess_round(29, 42)).to eq(4)
      expect(described_class.guess_round(29, 46)).to eq(5)
      expect(described_class.guess_round(29, 50)).to eq(6)
      expect(described_class.guess_round(29, 52)).to eq(7)
      expect(described_class.guess_round(29, 54)).to eq(8)
      expect(described_class.guess_round(29, 55)).to eq(9)
    end
  end
end
