module TournamentSystem
  module Algorithm
    # This module provides utility functions for helping implement other
    # algorithms.
    module Util
      extend self

      # @deprecated Please use {#padd_teams_even} instead.
      def padd_teams(teams)
        message = 'NOTE: padd_teams is now deprecated in favour of padd_teams_even. '\
                  'It will be removed in the next major version.'\
                  "Util.padd_teams called from #{Gem.location_of_caller.join(':')}"
        warn message unless Gem::Deprecate.skip

        padd_teams_even(teams)
      end

      # Padd an array of teams to be even.
      #
      # @param teams [Array<team>]
      # @return [Array<team, nil>]
      def padd_teams_even(teams)
        if teams.length.odd?
          teams + [nil]
        else
          teams
        end
      end

      # @deprecated Please use {#padded_teams_even_count}
      def padded_teams_count(teams_count)
        message = 'Node: padded_teams_count is now deprecated in favour of padded_teams_even_count. '\
                  'It will be removed in the next major version.'\
                  "Util.padded_teams_count called from #{Gem.location_of_caller.join(':')}"
        warn message unless Gem::Deprecate.skip

        padded_teams_even_count(teams_count)
      end

      # Padd the count of teams to be even.
      #
      # @example
      #   padded_teams_even_count(teams.length) == padd_teams_even(teams).length
      #
      # @param teams_count [Integer] the number of teams
      # @return [Integer]
      def padded_teams_even_count(teams_count)
        (teams_count / 2.0).ceil * 2
      end

      # pow2 is not uncommunicative
      # :reek:UncommunicativeMethodName

      # Padd an array of teams to the next power of 2.
      #
      # @param teams [Array<team>]
      # @return [Array<team, nil>]
      def padd_teams_pow2(teams)
        required = padded_teams_pow2_count(teams.length)

        Array.new(required) { |index| teams[index] }
      end

      # Padd the count of teams to be a power of 2.
      #
      # @example
      #   padded_teams_pow2_count(teams.length) == padd_teams_pow2(teams).length
      #
      # @param teams_count [Integer] the number of teams
      # @return [Integer]
      def padded_teams_pow2_count(teams_count)
        2**Math.log2(teams_count).ceil
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
