require 'tournament/algorithm/pairers/adjacent'

describe Tournament::Algorithm::Pairers::Adjacent do
  describe '#pair' do
    it 'works' do
      expect(described_class.pair([1, 2])).to eq([[1, 2]])
      expect(described_class.pair([1, 2, 3, 4])).to eq([[1, 2], [3, 4]])
    end
  end
end
