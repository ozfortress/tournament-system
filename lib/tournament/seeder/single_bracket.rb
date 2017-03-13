module Tournament
  module Seeder
    # A seeder for a single-bracket tournament system.
    # Seeds teams such that the highest expected placing teams should get
    # furthest in the bracket.
    module SingleBracket
      extend self

      def seed(teams)
        groups = teams.each_slice(2)

        top_half    = groups.map { |pair| pair[0] }
        bottom_half = groups.map { |pair| pair[1] }

        if top_half.length > 2
          top_half = seed top_half
          bottom_half = seed bottom_half
        end

        top_half + bottom_half
      end
    end
  end
end
