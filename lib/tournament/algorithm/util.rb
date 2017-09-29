module Tournament
  module Algorithm
    # This module provides utility functions for helping implement other
    # algorithms.
    module Util
      extend self

      # Padd an array of teams to be even.
      #
      # @param teams [Array<team>]
      # @return [Array<team, nil>]
      def padd_teams(teams)
        if teams.length.odd?
          teams + [nil]
        else
          teams
        end
      end

      # Padd the count of teams to be even.
      #
      # @example
      #   padded_teams_count(teams.length/) == padd_teams(teams).length
      #
      # @param teams_count [Integer] the number of teams
      # @return [Integer]
      def padded_teams_count(teams_count)
        (teams_count / 2.0).ceil * 2
      end

      # rubocop:disable Metrics/MethodLength

      # Collect all values in an array with a minimum value.
      #
      # @param array [Array<element>]
      # @yieldparam element an element of the array
      # @yieldreturn [#<, #==] some value to find the minimum of
      # @return [Array<element>] all elements with the minimum value
      def all_min_by(array)
        min_elements = []
        min_value = nil

        array.each do |element|
          value = yield element

          if !min_value || value < min_value
            min_elements = [element]
            min_value = value
          elsif value == min_value
            min_elements << element
          end
        end

        min_elements
      end
      # rubocop:enable Metrics/MethodLength
    end
  end
end
