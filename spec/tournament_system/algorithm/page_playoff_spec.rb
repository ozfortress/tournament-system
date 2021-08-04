describe TournamentSystem::Algorithm::PagePlayoff do
  describe '#guess_round' do
    it 'works for valid input' do
      expect(described_class.guess_round(0)).to eq(0)
      expect(described_class.guess_round(2)).to eq(1)
      expect(described_class.guess_round(3)).to eq(2)
    end

    it 'handles invalid input' do
      expect { described_class.guess_round(1) }.to raise_error ArgumentError
      expect { described_class.guess_round(4) }.to raise_error ArgumentError
      expect { described_class.guess_round(5) }.to raise_error ArgumentError
    end
  end
end
