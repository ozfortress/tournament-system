module Tournament
  module Seeder
    # Implements a fall-through tournament seeder. Does no seeding whatsoever.
    module None
      extend self

      def seed(teams)
        teams
      end
    end
  end
end
