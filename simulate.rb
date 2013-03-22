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

  opts.on("-w", "--werewolves n", Integer, "Werewolf count (default 1)") do |w|
    options[:werewolves] = w
  end

  opts.on("-v", "--villagers n", Integer, "Villager count (default 6)") do |v|
    options[:villagers] = v
  end

  opts.on("-s", "--seers n", Integer, "Seer count (default 0)") do |s|
    raise OptionParser::InvalidArgument, "We don't simulate more than one Seer" if s > 1
    options[:seers] = s
  end

  opts.on("-h", "--healers n", Integer, "Healer count (default 0)") do |h|
    raise OptionParser::InvalidArgument, "We don't simulate more than one Healer" if h > 1
    options[:healers] = h
  end

  opts.on("-r", "--runs n", Integer, "The number of simulations to run (default 5,000)") do |r|
    options[:runs] = r
  end

  opts.on("-c", "--combinator-type t", "Run in combinator mode (default is group_by_win_percentage") do |type|
    puts "0000"
    puts type
    options[:combinator] = type || 'player_number'
  end

  opts.on("-d", "--debug", "Run in debug mode (outputs details of individual games)") do
    options[:debug] = true
  end

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
options[:runs] ||= 5000

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
require_relative 'simulator'
require_relative 'combinator'

if options[:combinator]
  Combinator.go(options)
else
  Simulator.go(options)
end
