lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tournament_system/version'

Gem::Specification.new do |spec|
  spec.name          = 'tournament-system'
  spec.version       = TournamentSystem::VERSION
  spec.authors       = ['Benjamin Schaaf']
  spec.email         = ['ben.schaaf@gmail.com']

  spec.summary       = 'Implements various tournament systems'
  # TODO: Write a description
  # spec.description   =
  spec.homepage      = 'https://github.com/ozfortress/tournament-system'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'graph_matching', '~> 0.1.1'
  spec.add_development_dependency 'bundler', '~> 2.0'
end
