def require_relative(path)
  require File.join(File.dirname(caller[0]), path.to_str)
end

require 'rubygems'
require 'chance'
require 'ruby-debug'
require 'pp'

require_relative 'uno'

def simulate runs, *player_classes
  hist = {}
  uno = nil
  runouts = 0
  rounds = 0

  runs.times do
    uno = Uno.new
    player_classes.each { |_class| uno.players << _class.new }

    uno.play_round until uno.done?

    if uno.winner
      hist[uno.winner] ||= 0
      hist[uno.winner] += 1
    end

    rounds += uno.rounds
  end

  hist.each_with_index do |n, ix|
    share = runs / uno.players.size
    delta = n - share
    deltap = (delta.to_f / runs) * 100
    puts "%+0.2f%% %s" % [deltap, uno.players[ix].class]
  end

  puts "runouts: #{(runouts.to_f / runs.to_f) * 100.0}%"
  puts "avg rounds: #{ rounds.to_f / runs.to_f }"
  puts
end

simulate 500, Player, Player, Player, Player, Player, Werewolf
# simulate 10000, Player, Player, Player, Player, Player, Werewolf, Werewolf
# simulate 10000, Player, Player, Player, Player, Player, Werewolf, Werewolf, Werewolf

