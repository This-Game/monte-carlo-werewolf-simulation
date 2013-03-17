#!/bin/env ruby
# encoding: utf-8
require 'rubygems'
require 'chance'
require 'pp'
require 'optparse'

options = {}
opts_parser = OptionParser.new do |opts|
  opts.banner = "Usage: simulate [OPTIONS]"
  opts.separator  ""
  opts.separator  "Options"

  opts.on("-w", "--werewolves n", "Werewolf count (default 1)") do |w|
    options[:werewolves] = w
  end

  opts.on("-v", "--villagers n", "Villager count (default 6)") do |v|
    options[:villagers] = v
  end

  opts.on("-s", "--seers n", "Seer count (default 0)") do |s|
    options[:seers] = s
  end

  opts.on("-h", "--healers n", "Healer count (default 0)") do |h|
    options[:healers] = h
  end

  opts.on("-c", "--simulations n", Integer, "The number of simulations to run (default 5,000)") do |c|
    options[:simulations] = c
  end

  # opts.on("-o", "--output TYPE", "Output format, can be JSON or CSV") do |o|
  #   options[:output] = o
  # end

  opts.separator  ""
  opts.separator  "Examples:"
  opts.separator  ""
  opts.separator  "A 4 person game with 3 villagers, and one werewolf: "
  opts.separator  "\tsimulate -v 3 -w 1"
  opts.separator  ""
  opts.separator  "A 7 person game with 5 villagers, and two werewolves: "
  opts.separator  "\tsimulate -v 5 -w 2"
  opts.separator  ""
  opts.separator  "A 9 person game with 6 villagers, two werewolves, and a seer: "
  opts.separator  "\tsimulate -v 6 -w 2 -s 1"
  opts.separator  ""
  opts.separator  "A 9 person game with 5 villagers, two werewolves, a seer, and a healer: "
  opts.separator  "\tsimulate -v 6 -w 2 -s 1 -h 1"

end

options[:werewolves] ||= 1
options[:villagers] ||= 6
options[:seers] ||= 0
options[:healers] ||= 0
options[:simulations] ||= 5000

opts_parser.parse!

puts opts_parser

unless Kernel.respond_to? :require_relative
  module Kernel
    def require_relative(path)
      require File.join(File.dirname(caller[0]), path.to_str)
    end
  end
end

require_relative 'werewolf'

def simulate runs, *player_classes
  hist = {}
  game = nil
  rounds, phases = 0, 0

  runs.times do
    game = WerewolfGame.new
    player_classes.each { |_class| game.players << _class.new }

    until game.done?
      game.increment_round

      # Day first, then Night. Swap these for weirdoes who play starting with a nighttime killing phase.
      game.play_night_phase
      break if game.done?
      game.play_day_phase
    end

    if game.winner
      hist[game.winner] ||= 0
      hist[game.winner] += 1
    end

    rounds += game.rounds
    phases += game.phases
  end

  puts
  puts player_classes.to_s
  puts

  hist.keys.sort.each do |player_type|
    wins  = hist[player_type]
    share = (wins.to_f / runs) * 100
    if player_type == 'Villagers'
      puts "V |" + ("#" * share.to_i) +  ("–" * (100 - share).to_i) + "| W"
      puts
    end
    puts "#{player_type}: #{wins} wins, #{share.round(2)}%"
  end

  puts "avg rounds: #{ rounds.to_f / runs.to_f }"
  puts "avg phases: #{ phases.to_f / runs.to_f }"
  puts
  puts
end

simulate options[:simulations],
  * options[:villagers].times.collect{ Villager },
  * options[:werewolves].times.collect{ Werewolf },
  * options[:seers].times.collect{ Seer },
  * options[:healers].times.collect{ Healer }


