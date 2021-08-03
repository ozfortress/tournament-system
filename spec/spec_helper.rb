require 'simplecov'
require 'byebug'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new [
  SimpleCov::Formatter::HTMLFormatter,
]
SimpleCov.minimum_coverage 98
SimpleCov.start

require 'tournament_system'
require 'support/test_driver'
require 'support/soccer_test_driver'

RSpec.configure do |config|
  # Nicer specs
  config.expose_dsl_globally = true

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = :random
end
