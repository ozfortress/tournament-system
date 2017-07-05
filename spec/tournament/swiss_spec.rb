describe Tournament::Swiss do
  describe '#minimum_rounds' do
    it 'calls Algorithm::Swiss#minimum_rounds' do
      driver = instance_double('Driver')
      expect(driver).to receive(:seeded_teams) { [1, 2] }

      expect(Tournament::Algorithm::Swiss)
        .to receive(:minimum_rounds)
          .with(2) { 11 }

      expect(described_class.minimum_rounds(driver)).to eq(11)
    end
  end

  describe '#generate' do
    it 'calls pairer and generates matches' do
      driver = TestDriver.new
      expect(driver).to receive(:create_match).with(1, 2)
      expect(driver).to receive(:create_match).with(4, 3)

      pairer = instance_double('Pairer')
      expect(pairer).to receive(:pair).with(driver, 3) { [[1, 2], [4, 3]] }

      described_class.generate(driver, pairer: pairer, pair_options: 3)
    end
  end
end
