def require_relative(path)
  require File.join(File.dirname(caller[0]), path.to_str)
end

require 'rubygems'
require 'chance'
require 'ruby-debug'
require 'pp'

require_relative 'werewolf'

def simulate runs, *player_classes
  hist = {}
  game = nil
  rounds = 0

  runs.times do
    game = Werewolf.new
    player_classes.each { |_class| game.players << _class.new }

    game.play_round until game.done?

    if game.winner
      hist[game.winner] ||= 0
      hist[game.winner] += 1
    end

    rounds += game.rounds
  end

  pp player_classes.to_s
  hist.each_pair do |player_type, wins|
    share = (wins.to_f / runs) * 100

    pp "#{player_type}: #{wins} wins, #{share.round(2)}%"
    # delta = v - share
    # deltap = (delta.to_f / runs) * 100
    # puts "%+0.2f%% %s" % [deltap, k]
  end

  puts "avg rounds: #{ rounds.to_f / runs.to_f }"
  puts
end

simulate 5000, Player, Player, Player, Player, Player, Werewolf
simulate 5000, Player, Player, Player, Player, Player, Werewolf, Werewolf
simulate 5000, Player, Player, Player, Player, Player, Player, Player, Player, Player, Player, Werewolf, Werewolf



# simulate 10000, Player, Player, Player, Player, Player, Werewolf, Werewolf, Werewolf

