describe Tournament::Seeder::Random do
  describe '#seed' do
    it 'seeds teams randomly' do
      random = Random.new 123
      seeder = described_class.new(Random.new(random.seed))

      teams = [1, 2, 3]
      expect(seeder.seed(teams)).to eq(teams.shuffle(random: random))

      teams = [1, 2, 3, 4]
      expect(seeder.seed(teams)).to eq(teams.shuffle(random: random))
    end
  end
end
