describe Tournament::Swiss do
  describe '#minimum_rounds' do
    it 'works for valid input' do
      driver = TestDriver.new(teams: [1, 2, 3])
      expect(described_class.minimum_rounds(driver)).to eq(2)

      driver = TestDriver.new(teams: [1, 2])
      expect(described_class.minimum_rounds(driver)).to eq(1)

      driver = TestDriver.new(teams: [1])
      expect(described_class.minimum_rounds(driver)).to eq(0)

      driver = TestDriver.new(teams: (1..9).to_a)
      expect(described_class.minimum_rounds(driver)).to eq(4)
    end
  end

  context 'Dutch Pairings' do
    describe '#generate' do
      context 'first round' do
        it 'works for 4 teams' do
          driver = TestDriver.new(teams: [1, 2, 3, 4])
          described_class.generate driver

          expect(driver.created_matches.length).to eq(2)
          match1, match2 = driver.created_matches
          expect(match1.home_team).to eq(1)
          expect(match1.away_team).to eq(3)
          expect(match2.home_team).to eq(2)
          expect(match2.away_team).to eq(4)
        end

        it 'works for 5 teams' do
          driver = TestDriver.new(teams: [1, 2, 3, 4, 5])
          described_class.generate driver

          expect(driver.created_matches.length).to eq(3)
          match1, match2, match3 = driver.created_matches
          expect(match1.home_team).to eq(1)
          expect(match1.away_team).to eq(3)
          expect(match2.home_team).to eq(2)
          expect(match2.away_team).to eq(4)
          expect(match3.home_team).to eq(5)
          expect(match3.away_team).to be nil
        end

        it 'works for 16 teams' do
          driver = TestDriver.new(teams: (1..16).to_a)
          described_class.generate driver

          expect(driver.created_matches.length).to eq(8)
          matches = [
            [1, 9],
            [2, 10],
            [3, 11],
            [4, 12],
            [5, 13],
            [6, 14],
            [7, 15],
            [8, 16],
          ]
          driver.created_matches.zip(matches).each do |match, teams|
            expect(match.home_team).to eq(teams[0])
            expect(match.away_team).to eq(teams[1])
          end
        end
      end

      context 'full tournament' do
        it 'works for 8 teams' do
          teams = [1, 2, 3, 4, 5, 6, 7, 8]
          winners = {
            [1, 5] => 1,
            [2, 6] => 2,
            [3, 7] => 3,
            [4, 8] => 4,
            [1, 3] => 1,
            [2, 4] => 4,
            [1, 4] => 1,
            [5, 7] => 7,
            [6, 8] => 6,
          }
          driver = TestDriver.new(teams: teams, winners: winners)

          (1..3).each do |round|
            # Sort teams
            driver.teams = driver.teams.sort_by
                                 .with_index { |t, i| [-driver.scores[t], i] }
            described_class.generate driver, pair_options: { min_pair_size: 2 }

            driver.test_matches[round] = driver.created_matches.map do |match|
              match = [match.home_team, match.away_team]
              driver.scores[driver.get_match_winner(match)] += 1
              match
            end
            driver.created_matches = []
          end

          expect(driver.matches.length).to eq(12)
          teams.each do |team1|
            teams.each do |team2|
              next if team1 == team2

              expect(driver.matches.count do |match|
                match.include?(team1) && match.include?(team2)
              end).to be <= 1
            end

            matches_played = driver.matches.count do |match|
              match.include?(team1)
            end
            expect(matches_played).to eq(3)
          end
        end

        it 'works for 7 teams' do
          teams = [1, 2, 3, 4, 5, 6, 7]
          winners = {
            [1, 5] => 1,
            [2, 6] => 2,
            [3, 7] => 3,
            [4, 8] => 4,
            [1, 3] => 1,
            [2, 4] => 4,
            [1, 4] => 1,
            [5, 7] => 7,
            [6, 8] => 6,
          }
          driver = TestDriver.new(teams: teams, winners: winners)

          (1..3).each do |round|
            # Sort teams
            driver.teams = driver.teams.sort_by
                                 .with_index { |t, i| [-driver.scores[t], i] }
            described_class.generate driver, pair_options: { min_pair_size: 2 }

            driver.test_matches[round] = driver.created_matches.map do |match|
              match = [match.home_team, match.away_team]
              if match[1].nil?
                driver.scores[match[0]] += 1
              else
                driver.scores[driver.get_match_winner(match)] += 1
              end
              match
            end
            driver.created_matches = []
          end

          expect(driver.matches.length).to eq(12)
          teams.each do |team1|
            teams.each do |team2|
              next if team1 == team2

              expect(driver.matches.count do |match|
                match.include?(team1) && match.include?(team2)
              end).to be <= 1
            end

            matches_played = driver.matches.select do |match|
              match.include?(team1)
            end
            expect(matches_played.length).to be == 3
            byes = matches_played.select { |match| match[1].nil? }
            expect(byes.length).to be <= 1
          end
        end
      end
    end
  end
end
