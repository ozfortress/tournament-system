require 'graph_matching'

module Tournament
  module Algorithm
    # Implements graph matching algorithms for tournament systems.
    module Matching
      extend self

      # rubocop:disable Metrics/MethodLength
      # :reek:NestedIterators

      # Iterate all perfect matchings of a specific size. A perfect matchings is a unique grouping of all elements with
      # a specific group size.
      #
      # Note that iterating all perfect matchings can be expensive. The total amount of matchings for size +n+ is given
      # by +(n - 1)!!+, a double factorial.
      #
      # @example
      #   all_perfect_matchings([1, 2, 3, 4]).includes?([[1, 2], [3, 4]]) #=> true
      #
      # @param array [Array<element>]
      # @overload all_perfect_matchings(array, size)
      #   @return [Enumerator<Array<element>>] enumerator for all perfect matches
      # @overload all_perfect_matchings(array, size) { |group| ... }
      #   @yieldparam group [Array(element, size)] a group of elements
      #   @return [nil]
      def all_perfect_matchings(array)
        return to_enum(:all_perfect_matchings, array) unless block_given?

        if array.empty?
          yield []
          return
        end

        array[1..-1].combination(1) do |group|
          group.unshift array[0]

          remaining = array.reject { |element| group.include?(element) }
          all_perfect_matchings(remaining) do |groups|
            yield [group] + groups
          end
        end
      end
      # rubbocop:enable Metrics/MethodLength

      # Performs maximum weight perfect matching of a undirected complete graph composed of the given vertices.
      #
      # The block is called for every edge in the complete graph.
      #
      # Implementation performs in +O(v^3 log v)+.
      #
      # @param array [Array<element>]
      # @yieldparam first [element] The first element of an edge to compute the weight of.
      # @yieldparam second [element] The second element of an edge to compute the weight of.
      # @return [Array<Array(element, element)>] A perfect matching with maximum weight
      def maximum_weight_perfect_matching(array, &block)
        edges = create_complete_graph(array, &block)
        graph = GraphMatching::Graph::WeightedGraph[*edges]

        # Get the maximum weighted maximum cardinality matching of the complete graph
        matching = graph.maximum_weighted_matching(true)

        # Converted matching back to input values (remember, indecies start from 1 in this case)
        matching.edges.map do |edge|
          edge.map do |index|
            array[index - 1]
          end
        end
      end

      # Identical to {#maximum_weight_perfect_matching}, except instead of maximizing weight it minimizes it.
      #
      # This is simply achieved by negating the weight and then maximizing that.
      #
      # @param array [Array<element>]
      # @yieldparam first [element] The first element of an edge to compute the weight of.
      # @yieldparam second [element] The second element of an edge to compute the weight of.
      # @return [Array<Array(element, element)>] A perfect matching with minimum weight
      def minimum_weight_perfect_matching(array)
        maximum_weight_perfect_matching(array) do |first, second|
          -yield(first, second)
        end
      end

      private

      # Construct a complete graph from element indecies (starting from 1)
      def create_complete_graph(array)
        edges = []

        array.each.with_index do |first, first_index|
          next_index = first_index + 1

          array[next_index..array.length].each.with_index do |second, second_index|
            second_index += next_index

            edges << [next_index, second_index + 1, yield(first, second)]
          end
        end

        edges
      end
    end
  end
end
