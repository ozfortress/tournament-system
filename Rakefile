require 'bundler/gem_tasks'

require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'reek/rake/task'

RSpec::Core::RakeTask.new(:rspec)
RuboCop::RakeTask.new
Reek::Rake::Task.new

task default: :test
task test: %w(rspec lint)
task lint: %w(rubocop reek)
