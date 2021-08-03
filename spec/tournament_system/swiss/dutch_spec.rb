describe TournamentSystem::Swiss::Dutch do
  describe '#pair' do
    context 'first round' do
      it 'works for 4 teams' do
        driver = TestDriver.new(teams: [1, 2, 3, 4])
        matches = described_class.pair driver

        match1, match2 = matches
        expect(match1[0]).to eq(1)
        expect(match1[1]).to eq(3)
        expect(match2[0]).to eq(2)
        expect(match2[1]).to eq(4)
      end

      it 'works for 5 teams' do
        driver = TestDriver.new(teams: [1, 2, 3, 4, 5])
        matches = described_class.pair driver

        match1, match2, match3 = matches
        expect(match1[0]).to eq(1)
        expect(match1[1]).to eq(3)
        expect(match2[0]).to eq(2)
        expect(match2[1]).to eq(4)
        expect(match3[0]).to be nil
        expect(match3[1]).to eq(5)
      end

      it 'works for 16 teams' do
        driver = TestDriver.new(teams: (1..16).to_a)
        matches = described_class.pair driver

        expected = [
          [1, 9],
          [2, 10],
          [3, 11],
          [4, 12],
          [5, 13],
          [6, 14],
          [7, 15],
          [8, 16],
        ]
        matches.zip(expected).each do |match, expected_match|
          expect(match).to eq(expected_match)
        end
      end
    end

    context 'full tournament' do
      it 'works for 16 teams' do
        teams = (1..16).to_a.freeze
        scores = teams.map { |t| [t, 0] }.to_h

        matches = []

        round_count = 15
        match_count_per_round = TournamentSystem::Algorithm::Util.padded_teams_even_count(teams.length) / 2
        round_count.times do
          ranked_teams = teams.sort_by
                              .with_index { |t, i| [-scores[t], i] }
                              .freeze

          driver = TestDriver.new(ranked_teams: ranked_teams, scores: scores,
                                  matches: matches)

          created_matches = described_class.pair driver
          expect(created_matches.length).to eq(match_count_per_round)
          matches += created_matches

          created_matches.each do |match|
            expect(match[0] && match[1]).to_not be nil
            scores[match.min] += 1
          end
        end

        expect(matches.length).to eq(round_count * match_count_per_round)
        teams.each do |team1|
          teams.each do |team2|
            next if team1 == team2

            expect(matches.count do |match|
              match.include?(team1) && match.include?(team2)
            end).to be <= 1
          end

          matches_played = matches.count do |match|
            match.include?(team1)
          end
          expect(matches_played).to eq(round_count)
        end
      end

      it 'works for 15 teams' do
        teams = (1..15).to_a.freeze
        scores = teams.map { |t| [t, 0] }.to_h

        matches = []

        round_count = 15
        match_count_per_round = TournamentSystem::Algorithm::Util.padded_teams_even_count(teams.length) / 2
        round_count.times do
          ranked_teams = teams.sort_by
                              .with_index { |t, i| [-scores[t], i] }
                              .freeze

          driver = TestDriver.new(ranked_teams: ranked_teams, scores: scores,
                                  matches: matches)

          created_matches = described_class.pair driver
          expect(created_matches.length).to eq(match_count_per_round)
          matches += created_matches

          created_matches.each do |match|
            if match[1].nil?
              driver.scores[match[0]] += 1
            elsif match[0].nil?
              driver.scores[match[1]] += 1
            else
              driver.scores[match.min] += 1
            end
          end
        end

        expect(matches.length).to eq(round_count * match_count_per_round)
        teams.each do |team1|
          teams.each do |team2|
            next if team1 == team2

            expect(matches.count do |match|
              match.include?(team1) && match.include?(team2)
            end).to be <= 1
          end

          matches_played = matches.select do |match|
            match.include?(team1)
          end
          expect(matches_played.length).to be == round_count
          byes = matches_played.select { |match| match[1].nil? }
          expect(byes.length).to be <= 1
        end
      end
    end

    it 'minimises duplicate matches' do
      teams = [1, 2, 3].freeze
      matches = [
        [1, 2], [3, nil],
        [1, 3], [2, nil],
        [2, 3], [1, nil],
        [1, 2], [3, nil],
        [1, 3], [2, nil],
      ].freeze
      scores = { 1 => 1, 2 => 2, 3 => 3 }.freeze
      driver = TestDriver.new(teams: teams, matches: matches, scores: scores)

      created_matches = described_class.pair driver

      match1, match2 = created_matches
      expect(match1[0]).to eq(nil)
      expect(match1[1]).to eq(1)
      expect(match2[0]).to eq(3)
      expect(match2[1]).to be(2)
    end

    it 'handles no minimum sized groups' do
      teams = [1, 2, 3, 4].freeze
      matches = [[1, 2], [3, 4], [2, 3], [1, 4], [1, 3], [2, 4]].freeze
      scores = { 1 => 1, 2 => 2, 3 => 3, 4 => 4 }.freeze
      driver = TestDriver.new(teams: teams, matches: matches, scores: scores)

      created_matches = described_class.pair driver
      expect(created_matches.length).to eq(2)

      created_matches = described_class.pair driver
      expect(created_matches.length).to eq(2)

      created_matches = described_class.pair driver
      expect(created_matches.length).to eq(2)
    end

    it 'handles no minimum sized groups with byes' do
      teams = [1, 2, 3].freeze
      matches = [[1, 2], [3, nil], [2, 3], [1, nil], [1, 3], [2, nil]].freeze
      scores = { 1 => 1, 2 => 2, 3 => 3 }.freeze
      driver = TestDriver.new(teams: teams, matches: matches, scores: scores)

      created_matches = described_class.pair driver
      expect(created_matches.length).to eq(2)

      created_matches = described_class.pair driver
      expect(created_matches.length).to eq(2)

      created_matches = described_class.pair driver
      expect(created_matches.length).to eq(2)
    end
  end
end
