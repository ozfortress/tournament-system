describe Tournament::Algorithm::Pairers::Halves do
  it 'pairs even teams' do
    expect(described_class.pair((1..2).to_a)).to eq([[1, 2]])
    expect(described_class.pair((1..4).to_a)).to eq([[1, 3], [2, 4]])
    expect(described_class.pair((1..6).to_a)).to eq([[1, 4], [2, 5], [3, 6]])
    expect(described_class.pair((1..8).to_a)).to eq([[1, 5], [2, 6],
                                                     [3, 7], [4, 8]])
  end

  it 'pairs even teams with bottom reversed' do
    pair = ->(teams) { described_class.pair(teams, bottom_reversed: true) }

    expect(pair.call((1..2).to_a)).to eq([[1, 2]])
    expect(pair.call((1..4).to_a)).to eq([[1, 4], [2, 3]])
    expect(pair.call((1..6).to_a)).to eq([[1, 6], [2, 5], [3, 4]])
    expect(pair.call((1..8).to_a)).to eq([[1, 8], [2, 7], [3, 6], [4, 5]])
  end
end
