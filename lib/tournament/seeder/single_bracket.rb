module Tournament
  module Seeder
    module SingleBracket
      extend self

      def seed(teams)
        top_half = []
        bottom_half = []

        teams.each_slice(2) do |slice|
          top_half << slice[0]
          bottom_half << slice[1]
        end

        if top_half.length > 2
          top_half = seed top_half
          bottom_half = seed bottom_half
        end

        top_half + bottom_half
      end
    end
  end
end
