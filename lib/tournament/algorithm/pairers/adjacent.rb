module Tournament
  module Algorithm
    module Pairers
      # Basic pairer for adjacent teams.
      module Adjacent
        extend self

        # Pair adjacent teams.
        #
        # @example
        #   pair([1, 2, 3, 4]) #=> [[1, 2], [3, 4]]
        #
        # @param teams [Array<team>]
        # @return [Array<Array(team, team)>]
        def pair(teams)
          teams.each_slice(2).to_a
        end
      end
    end
  end
end
