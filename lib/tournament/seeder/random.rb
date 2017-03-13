module Tournament
  module Seeder
    # A random seeder.
    class Random
      def initialize(random = nil)
        @random = random
      end

      def seed(teams)
        teams.shuffle(random: @random)
      end
    end
  end
end
