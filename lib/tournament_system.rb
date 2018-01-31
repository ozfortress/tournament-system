require 'tournament_system/version'
require 'tournament_system/driver'

require 'tournament_system/swiss'
require 'tournament_system/round_robin'
require 'tournament_system/page_playoff'
require 'tournament_system/single_elimination'

# This library is split into two parts, there's the actual algorithms that implement various tournament systems
# ({Algorithm}) and a data abstraction layer for generating matches using various tournament systems in a
# data-independent way ({Driver}), along with matching implementations of tournament systems using drivers.
#
# TournamentSystem currently supports the following systems:
#
# * {https://en.wikipedia.org/wiki/Single-elimination_tournament Single elimination}
#   ({TournamentSystem::SingleElimination})
# * {https://en.wikipedia.org/wiki/Page_playoff_system Page playoffs} ({TournamentSystem::PagePlayoff})
# * {https://en.wikipedia.org/wiki/Round-robin_tournament Round robin} ({TournamentSystem::RoundRobin})
# * {https://en.wikipedia.org/wiki/Swiss-system_tournament Swiss-system} ({TournamentSystem::Swiss}) with support for
#   multiple types of pairing systems:
#
#   * Dutch pairing (very popular) ({TournamentSystem::Swiss::Dutch})
#   * Accelerated pairing (aka Accelerated swiss) ({TournamentSystem::Swiss::AcceleratedDutch})
module TournamentSystem
end
