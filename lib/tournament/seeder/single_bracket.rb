module Tournament
  module Seeder
    # A seeder for a single-bracket tournament system.
    # Seeds teams such that the highest expected placing teams should get
    # furthest in the bracket.
    module SingleBracket
      extend self

      def seed(teams)
        unless (Math.log2(teams.length) % 1).zero?
          raise ArgumentError, 'Need power-of-2 teams'
        end

        teams = teams.map.with_index { |team, index| SeedTeam.new(team, index) }
        seed_bracket(teams).map(&:team)
      end

      private

      # Structure for wrapping a team with it's seed index
      SeedTeam = Struct.new(:team, :index)

      # Recursively seed the top half of the teams
      # and match teams reversed by index to the bottom half
      def seed_bracket(teams)
        return teams if teams.length <= 2

        top_half, bottom_half = teams.each_slice(teams.length / 2).to_a
        top_half = seed top_half

        top_half.map do |team|
          match = bottom_half[-team.index - 1]

          [team, match]
        end.flatten
      end
    end
  end
end
