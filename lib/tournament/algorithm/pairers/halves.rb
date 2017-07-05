module Tournament
  module Algorithm
    module Pairers
      # Basic pairer that matches the top half with the bottom half
      module Halves
        extend self

        # Pair the top half of teams with the bottom half.
        #
        # @example
        #   pair([1, 2, 3, 4]) #=> [[1, 3], [2, 4]]
        #
        # @example
        #   pair([1, 2, 3, 4], bottom_reversed: true) #=> [[1, 4], [2, 3]]
        #
        # @param teams [Array<team>]
        # @param bottom_reversed [Boolean] whether to reverse the bottom half
        #                                  before pairing both halves.
        # @return [Array<Array(team, team)>]
        # :reek:BooleanParameter
        # :reek:ControlParameter
        def pair(teams, bottom_reversed: false)
          top, bottom = teams.each_slice(teams.length / 2).to_a

          bottom.reverse! if bottom_reversed

          top.zip(bottom).to_a
        end
      end
    end
  end
end
