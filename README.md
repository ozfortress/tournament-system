# Tournament System

[![Build Status](https://travis-ci.org/ozfortress/tournament-system.svg?branch=master)](https://travis-ci.org/ozfortress/tournament-system)
[![Coverage Status](https://coveralls.io/repos/github/ozfortress/tournament-system/badge.svg?branch=master)](https://coveralls.io/github/ozfortress/tournament-system?branch=master)
[![Gem Version](https://badge.fury.io/rb/tournament-system.svg)](https://badge.fury.io/rb/tournament-system)

This is a simple gem that implements numerous tournament systems.

It is designed to easily fit into any memory model you might already have.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tournament-system'
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install tournament-system
```

## Usage

First you need to implement a driver to handle the interface between your data
and the tournament systems:

```ruby
class Driver < Tournament::Driver
  def matches
    ...
  end

  def matches_for_round(round)
    ...
  end

  def seeded_teams
    ...
  end

  def ranked_teams
    ...
  end

  def get_match_winner(match)
    ...
  end

  def get_match_teams(match)
    ...
  end

  def get_team_score(team)
    ...
  end

  def build_match(home_team, away_team)
    ...
  end
end
```

Then you can simply generate matches for any tournament system using a driver
instance:

```ruby
driver = Driver.new

# Generate the 3rd round of a single elimination tournament
Tournament::SingleElimination.generate driver, round: 2

# Generate a round for a round robin tournament, guesses round automatically
Tournament::RoundRobin.generate driver

# Generate a round for a swiss system tournament
# with Dutch pairings (default) with a minimum pair size of 6
Tournament::Swiss.generate driver, pairer: Tournament::Swiss::Dutch,
                                   pair_options: { min_pair_size: 6 }

# Generate a round for a page playoff system, with an optional bronze match
Tournament::PagePlayoff.generate driver, bronze_match: true
```

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/ozfortress/tournament-system.

## License

The gem is available as open source under the terms of the
[MIT License](http://opensource.org/licenses/MIT).
