describe Tournament::Algorithm::Pairers::Halves do
  def gen_teams(num)
    (1..num).to_a.freeze
  end

  it 'pairs even teams' do
    expect(described_class.pair(gen_teams(2))).to eq([[1, 2]])
    expect(described_class.pair(gen_teams(4))).to eq([[1, 3], [2, 4]])
    expect(described_class.pair(gen_teams(6))).to eq([[1, 4], [2, 5], [3, 6]])
    expect(described_class.pair(gen_teams(8))).to eq([[1, 5], [2, 6],
                                                      [3, 7], [4, 8]])
  end

  it 'pairs even teams with bottom reversed' do
    pair = ->(teams) { described_class.pair(teams, bottom_reversed: true) }

    expect(pair.call(gen_teams(2))).to eq([[1, 2]])
    expect(pair.call(gen_teams(4))).to eq([[1, 4], [2, 3]])
    expect(pair.call(gen_teams(6))).to eq([[1, 6], [2, 5], [3, 4]])
    expect(pair.call(gen_teams(8))).to eq([[1, 8], [2, 7], [3, 6], [4, 5]])
  end
end
