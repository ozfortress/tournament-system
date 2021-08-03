require 'bundler/gem_tasks'

require 'rspec/core/rake_task'
require 'rubocop/rake_task'

RSpec::Core::RakeTask.new(:rspec)
RuboCop::RakeTask.new

task default: :test
task test: %w[rspec lint]
task lint: %w[rubocop]
