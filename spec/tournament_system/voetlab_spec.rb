describe TournamentSystem::Voetlab do
  describe '#minimum_rounds' do
    it 'calls Algorithm::Swiss#minimum_rounds' do
      driver = instance_double('Driver')
      expect(described_class.minimum_rounds(driver)).to eq(1)
    end
  end

  describe '#generate' do
    it 'completes the round robin' do
      driver = TestDriver.new(
        teams: [1, 2, 3, 4, 5],
        matches: [[1, 2], [3, 4], [5, nil], [1, 3], [5, 2], [4, nil], [1, 5], [3, nil], [4, 2], [1, nil], [4, 5],
                  [2, 3],]
      )

      matches = described_class.generate(driver, pairer: TournamentSystem::Swiss::Dutch,
                                                 pair_options: { push_byes_to: :lowest_score })

      expect(matches).to eq [
        [1, 4], [5, 3], [2, nil],
      ]
    end

    it 'and generates matches' do
      driver = TestDriver.new(teams: [1, 2, 3, 4, 5], scores: { 1 => 5, 2 => 4, 3 => 3, 4 => 2, 5 => 1 })

      matches = described_class.generate(driver, pairer: TournamentSystem::Swiss::Dutch,
                                                 pair_options: { push_byes_to: :lowest_score })

      # Should match strongest teams together
      expect(matches).to eq [
        [1, 2], [5, nil], [3, 4],
      ]
    end

    it 'generates matches round 2' do
      driver = TestDriver.new(
        teams: [1, 2, 3, 4, 5],
        matches: [[1, 2], [3, 4], [5, nil]],
        winners: { [1, 2] => 1, [3, 4] => 3, [5, nil] => 5 },
        scores: { 1 => 3, 2 => 0, 3 => 3, 4 => 0, 5 => 3 } # Scores based on match results
      )

      matches = described_class.generate(driver, pairer: TournamentSystem::Swiss::Dutch,
                                                 pair_options: { push_byes_to: :lowest_score })

      # Should pit winners against winners and losers against losers
      # with a bye for the team with the lowest score
      expect(matches).to eq [
        [1, 4], [3, 5], [2, nil],
      ]
    end

    it 'generates matches round 3' do
      driver = TestDriver.new(
        teams: [1, 2, 3, 4, 5],
        matches: [[1, 2], [3, 4], [5, nil], [1, 5], [4, 2], [3, nil]],
        winners: { [1, 2] => 1, [3, 4] => 3, [5, nil] => 5, [1, 5] => 5, [4, 2] => 2, [3, nil] => 3 },
        scores: { 1 => 3, 2 => 3, 3 => 6, 4 => 0, 5 => 6 } # Scores based on match results
      )

      matches = described_class.generate(driver, pairer: TournamentSystem::Swiss::Dutch,
                                                 pair_options: { push_byes_to: :lowest_score })

      expect(matches).to eq [
        [1, 3], [4, nil], [2, 5],
      ]
    end

    it 'generates matches round 4' do
      driver = TestDriver.new(
        teams: [1, 2, 3, 4, 5],
        matches: [[1, 2], [3, 4], [5, nil], [1, 5], [4, 2], [3, nil], [1, 3], [4, nil], [2, 5]],
        winners: { [1, 2] => 1, [3, 4] => 3, [5, nil] => 5, [1, 5] => 5, [4, 2] => 2, [3, nil] => 3, [1, 3] => 1,
                   [4, nil] => 4, [2, 5] => 5, },
        scores: { 1 => 6, 2 => 3, 3 => 6, 4 => 3, 5 => 9 } # Scores based on match results
      )

      matches = described_class.generate(driver, pairer: TournamentSystem::Swiss::Dutch,
                                                 pair_options: { push_byes_to: :lowest_score })

      expect(matches).to eq [
        [1, 4], [3, 5], [2, nil],
      ]
    end

    it 'generates matches round 5' do
      driver = TestDriver.new(
        teams: [1, 2, 3, 4, 5],
        matches: [[1, 2], [3, 4], [5, nil], [1, 5], [4, 2], [3, nil], [1, 3], [4, nil], [2, 5], [1, 4], [3, 5],
                  [2, nil],],
        winners: { [1, 2] => 1, [3, 4] => 3, [5, nil] => 5, [1, 5] => 5, [4, 2] => 2, [3, nil] => 3, [1, 3] => 1,
                   [4, nil] => 4, [2, 5] => 5, [1, 4] => 1, [3, 5] => 5, [2, nil] => 2, },
        scores: { 1 => 9, 2 => 6, 3 => 6, 4 => 3, 5 => 12 } # Scores based on match results
      )

      matches = described_class.generate(driver, pairer: TournamentSystem::Swiss::Dutch,
                                                 pair_options: { push_byes_to: :lowest_score })

      expect(matches).to eq [
        [1, nil], [2, 3], [4, 5],
      ]
    end

    it 'calls generates matches round 6' do
      driver = TestDriver.new(
        teams: [1, 2, 3, 4, 5],
        matches: [[1, 2], [3, 4], [5, nil], [1, 5], [4, 2], [3, nil], [1, 3], [4, nil], [2, 5], [1, 4], [3, 5],
                  [2, nil], [1, nil], [2, 3], [4, 5],],
        winners: {
          [1, 2] => 1, [3, 4] => 3, [5, nil] => 5,
          [1, 5] => 5, [4, 2] => 2, [3, nil] => 3,
          [1, 3] => 1, [4, nil] => 4, [2, 5] => 5,
          [1, 4] => 1, [3, 5] => 5, [2, nil] => 2,
          [1, nil] => 1, [2, 3] => 3, [4, 5] => 5,
        },
        scores: { 1 => 12, 2 => 6, 3 => 9, 4 => 3, 5 => 15 } # Scores based on match results
      )

      matches = described_class.generate(driver, pairer: TournamentSystem::Swiss::Dutch,
                                                 pair_options: { push_byes_to: :lowest_score })

      # Since this is a new lap of round robin, teams should again be matched solely based on score
      expect(matches).to eq [
        [1, 5], [4, nil], [2, 3],
      ]
    end
  end

  describe '#available_round_robin_rounds' do
    let(:teams) { [1, 2, 3, 4, 5] }
    let(:matches) { [] }
    let(:driver) { TestDriver.new(teams: teams, matches: matches) }

    context 'first round' do
      it 'returns all possible rounds' do
        rounds = described_class.available_round_robin_rounds(driver)

        # In the first rounds, all possible permutations of teams should still be possible
        teams.permutation.each do |_ordered_teams|
          expect(rounds).to include Set[Set[teams[0], teams[1]], Set[teams[2], teams[3]], Set[teams[4], nil]]
        end
      end
    end

    context 'second round' do
      let(:matches) { [[1, 2], [3, 4], [5, nil]] }

      it 'returns only valid rounds' do
        rounds = described_class.available_round_robin_rounds(driver)

        # Should not include any of the played matches
        rounds.each do |round|
          expect(round).not_to include Set[1, 2]
          expect(round).not_to include Set[3, 4]
          expect(round).not_to include Set[5, nil]
        end

        # First permutation ("team 1 locked in place")
        expect(rounds).to include Set[Set[1, 3], Set[5, 2], Set[nil, 4]]
        expect(rounds).to include Set[Set[1, 5], Set[nil, 3], Set[4, 2]]
        expect(rounds).to include Set[Set[1, nil], Set[4, 5], Set[2, 3]]
        expect(rounds).to include Set[Set[1, 4], Set[2, nil], Set[3, 5]]

        # Second permutation ("team 2 locked in place")
        expect(rounds).to include Set[Set[3, 2], Set[5, 1], Set[nil, 4]]
        expect(rounds).to include Set[Set[5, 2], Set[nil, 3], Set[4, 1]]
        expect(rounds).to include Set[Set[nil, 2], Set[4, 5], Set[1, 3]]
        expect(rounds).to include Set[Set[4, 2], Set[1, nil], Set[3, 5]]

        # ...four more permutations not tested

        # FIXME: Test Team 1 should be able to play against every team (except 2)
      end
    end

    context 'third round' do
      let(:matches) { [[1, 2], [3, 4], [5, nil], [1, 3], [5, 2], [4, nil]] }

      it 'returns only valid rounds' do
        rounds = described_class.available_round_robin_rounds(driver)

        # Should not include any of the played matches
        rounds.each do |round|
          expect(round).not_to include Set[1, 2]
          expect(round).not_to include Set[3, 4]
          expect(round).not_to include Set[5, nil]
          expect(round).not_to include Set[1, 3]
          expect(round).not_to include Set[5, 2]
          expect(round).not_to include Set[4, nil]
        end

        # Only a single round robin permutation remains
        expect(rounds.to_set).to eq Set[
          Set[Set[1, 5], Set[nil, 3], Set[4, 2]],
          Set[Set[1, nil], Set[4, 5], Set[2, 3]],
          Set[Set[1, 4], Set[2, nil], Set[3, 5]]
        ]
      end
    end

    context 'fourth round' do
      let(:matches) { [[1, 2], [3, 4], [5, nil], [1, 3], [5, 2], [4, nil], [1, 4], [3, 5], [2, nil]] }

      it 'returns only valid rounds' do
        rounds = described_class.available_round_robin_rounds(driver)

        # Should not include any of the played matches
        rounds.each do |round|
          expect(round).not_to include Set[1, 2]
          expect(round).not_to include Set[3, 4]
          expect(round).not_to include Set[5, nil]
          expect(round).not_to include Set[1, 3]
          expect(round).not_to include Set[5, 2]
          expect(round).not_to include Set[4, nil]
          expect(round).not_to include Set[1, 4]
          expect(round).not_to include Set[3, 5]
          expect(round).not_to include Set[2, nil]
        end

        expect(rounds.to_set).to eq Set[
          Set[Set[1, 5], Set[nil, 3], Set[4, 2]],
          Set[Set[1, nil], Set[4, 5], Set[2, 3]]
        ]
      end
    end

    context 'fifth round' do
      let(:matches) do
        [[1, 2], [3, 4], [5, nil], [1, 3], [5, 2], [4, nil], [1, 4], [3, 5], [2, nil], [1, 5], [3, nil], [4, 2]]
      end

      it 'returns only valid rounds' do
        rounds = described_class.available_round_robin_rounds(driver)

        # Should not include any of the played matches
        rounds.each do |round|
          expect(round).not_to include Set[1, 2]
          expect(round).not_to include Set[3, 4]
          expect(round).not_to include Set[5, nil]
          expect(round).not_to include Set[1, 3]
          expect(round).not_to include Set[5, 2]
          expect(round).not_to include Set[4, nil]
          expect(round).not_to include Set[1, 4]
          expect(round).not_to include Set[3, 5]
          expect(round).not_to include Set[2, nil]
          expect(round).not_to include Set[1, 5]
          expect(round).not_to include Set[3, nil]
          expect(round).not_to include Set[4, 2]
        end

        expect(rounds.to_set).to eq Set[
          Set[Set[1, nil], Set[4, 5], Set[2, 3]]
        ]
      end
    end
  end
end
