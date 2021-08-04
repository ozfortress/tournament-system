require 'ostruct'

module TournamentSystem
  module Swiss
    # A Dutch pairing system implementation.
    module Voetlab
      extend Dutch

      def pair(driver, options = {})
        state = build_state(driver, options)

        generate_best_pairings(state)
      end
    end
  end
end
