require 'tournament_system/version'
require 'tournament_system/driver'

require 'tournament_system/swiss'
require 'tournament_system/round_robin'
require 'tournament_system/page_playoff'
require 'tournament_system/single_elimination'

# This library is split into two parts, there's the actual algorithms that
# implement various tournament systems ({Algorithm}) and a data abstraction
# layer for generating matches using various tournament systems in a
# data-independent way ({Driver}).
module TournamentSystem
end
