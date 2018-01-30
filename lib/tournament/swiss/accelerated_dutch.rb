require 'tournament/swiss/dutch'
require 'tournament/driver_proxy'

module Tournament
  module Swiss
    # A implementation of accelerated (dutch) swiss pairing
    module AcceleratedDutch
      extend self

      # Pair teams using the accelerated (dutch) swiss pairing system.
      #
      # Behaves identical to the dutch pairing system, except that for the first N rounds the top half of the seeded
      # teams is given a point bonus. This makes the first couple rounds of a tournament accelerate 1 round ahead of
      # swiss.
      #
      # Options are passed to the dutch system and behave identically.
      #
      # @param driver [Driver]
      # @option options [Integer] acceleration_rounds determines how many round to perform the acceleration for. This
      #     should be shorter than the length of the tournament in order to produce fair results.
      # @option options [Integer] acceleration_points determines how many points to grant the teams. This should be
      #     approximately equal to the number of points usually granted in one round.
      # @return [Array<Array(team, team)>] the generated pairs of teams
      def pair(driver, options = {})
        acceleration_rounds = options[:acceleration_rounds] || 2
        acceleration_points = options[:acceleration_points] || 1

        # Accelerate for the first N rounds by replacing the driver with an accelerated one
        driver = accelerate_driver(driver, acceleration_points) if Swiss.guess_round(driver) < acceleration_rounds

        # Do a regular dutch pairing
        Dutch.pair(driver, options)
      end

      private

      def accelerate_driver(driver, acceleration_points)
        teams = driver.seeded_teams
        top_half = Set.new teams[0..teams.length / 2]

        # Accelerated dutch is identical to dutch, except that we give the top half an extra point for the first 2
        # rounds. To do that we just proxy the driver and add one point.
        AcceleratedDutchDriverProxy.new(driver, top_half, acceleration_points)
      end

      # Driver proxy for implementing a score bonus
      class AcceleratedDutchDriverProxy < DriverProxy
        def initialize(target, accelerated_teams, acceleration_points)
          super(target)

          @accelerated_teams = accelerated_teams
          @acceleration_points = acceleration_points
        end

        def get_team_score(team)
          original_score = super(team)

          if @accelerated_teams.include?(team)
            original_score + @acceleration_points
          else
            original_score
          end
        end
      end

      private_constant :AcceleratedDutchDriverProxy
    end
  end
end
