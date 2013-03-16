require 'rubygems'
require 'chance'
require 'ruby-debug'
require 'pp'

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
  rounds = 0

  runs.times do
    game = WerewolfGame.new
    player_classes.each { |_class| game.players << _class.new }

    until game.done?
      game.increment_round
      game.play_day_phase
      break if game.done?
      game.play_night_phase

    end

    if game.winner
      hist[game.winner] ||= 0
      hist[game.winner] += 1
    end

    rounds += game.rounds
  end

  puts player_classes.to_s
  hist.keys.sort.each do |player_type|
    wins  = hist[player_type]
    share = (wins.to_f / runs) * 100
    if player_type == 'Villagers'
      puts "V |" + ("#" * share.to_i) +  ("-" * (100 - share).to_i) + "| W"
      puts
    end
    puts "#{player_type}: #{wins} wins, #{share.round(2)}%"
  end

  puts "avg rounds: #{ rounds.to_f / runs.to_f }"
  puts
  puts
end

simulate 5000, Player, Player, Player,  Werewolf
simulate 5000, Player, Player, Player, Player, Werewolf
simulate 5000, Player, Player, Player, Player, Player, Werewolf

simulate 5000, Player, Player, Player, Player, Player, Player, Werewolf
simulate 5000, Player, Player, Player, Player, Player, Seer, Werewolf

simulate 5000, Player, Player, Player, Player, Player, Player, Werewolf, Werewolf
simulate 5000, Player, Player, Player, Player, Player, Seer, Werewolf, Werewolf

# simulate 5000, Player, Player, Player, Player, Player, Player, Player, Player, Player, Player,Player, Player, Player, Player, Player,Player, Player, Player, Player, Player, Player, Werewolf

