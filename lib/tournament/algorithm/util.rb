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

      # rubocop:disable Metrics/MethodLength
      # :reek:NestedIterators

      # Iterate all perfect matches of a specific size.
      # A perfect matching is a unique grouping of all elements with a specific
      # group size. For example +[[1, 2], [3, 4]]+ is a perfect match of
      # +[1, 2, 3, 4]+ with group size of +2+.
      #
      # This is useful for example when a pairing algorithm needs to iterate all
      # possible pairings of teams to determine which is the best.
      #
      # Warning, this currently only works for +size = 2+.
      #
      # @param array [Array<element>]
      # @param size [Integer] the size of groups
      # @overload all_perfect_matches(array, size)
      #   @return [Enumerator<Array<element>>] enumerator for all perfect
      #                                        matches
      # @overload all_perfect_matches(array, size) { |group| ... }
      #   @yieldparam group [Array(element, size)] a group of elements
      #   @return [void]
      def all_perfect_matches(array, size)
        size = 2
        return to_enum(:all_perfect_matches, array, size) unless block_given?

        if array.empty?
          yield []
          return
        end

        array[1..-1].combination(size - 1) do |group|
          group.unshift array[0]

          remaining = array.reject { |element| group.include?(element) }
          all_perfect_matches(remaining, size) do |groups|
            yield [group] + groups
          end
        end
      end
      # rubbocop:enable Metrics/MethodLength
    end
  end
end
