require 'tournament-system/version'
require 'tournament-system/driver'

require 'tournament-system/swiss'
require 'tournament-system/round_robin'
require 'tournament-system/page_playoff'
require 'tournament-system/single_elimination'

# This library is split into two parts, there's the actual algorithms that
# implement various tournament systems ({Algorithm}) and a data abstraction
# layer for generating matches using various tournament systems in a
# data-independent way ({Driver}).
module TournamentSystemSystem
end
