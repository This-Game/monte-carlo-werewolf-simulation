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
    game = WerewolfGame.new
    player_classes.each { |_class| game.players << _class.new }

    until game.done?
      game.increment_round
      game.play_night_phase
      break if game.done?
      game.play_day_phase
    end

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
  end

  puts "avg rounds: #{ rounds.to_f / runs.to_f }"
  puts
end

simulate 10, Player, Player, Player,  Werewolf
# simulate 5000, Player, Player, Player, Player, Werewolf
# simulate 5000, Player, Player, Player, Player, Player, Werewolf
# simulate 5000, Player, Player, Player, Player, Player, Player, Werewolf
# simulate 5000, Player, Player, Player, Player, Player, Player, Player, Werewolf


# simulate 5000, Player, Player, Player, Player, Player, Player, Player, Player, Player, Player,Player, Player, Player, Player, Player,Player, Player, Player, Player, Player, Player, Werewolf
# simulate 5000, Player, Player, Player, Player, Player, Werewolf
# simulate 5000, Player, Player, Player, Player, Player, Werewolf
# simulate 5000, Player, Player, Player, Player, Player, Werewolf
# simulate 5000, Player, Player, Player, Player, Player, Werewolf
# simulate 5000, Player, Player, Player, Player, Player, Werewolf
# simulate 5000, Player, Player, Player, Player, Player, Werewolf



# simulate 5000, Player, Player, Player, Player, Player, Werewolf, Werewolf
# simulate 5000, Player, Player, Player, Player, Player, Player, Player, Player, Player, Player, Werewolf, Werewolf

