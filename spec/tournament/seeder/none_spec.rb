describe Tournament::Seeder::None do
  describe '#seed' do
    it 'passes through' do
      teams = [1, 2, 3].freeze
      expect(described_class.seed(teams)).to be(teams)

      teams = [1, 2, 3, 4].freeze
      expect(described_class.seed(teams)).to be(teams)
    end
  end
end
