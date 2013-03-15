require_relative 'player'

class WerewolfGame
  attr_reader :rounds, :winner, :players

  def initialize
    @players = []

    # stats
    @rounds = 0
    @winner = nil
  end

  def done?
    wolves, villagers = @players.partition {|player| player.is_werewolf? }
    if wolves.empty?
      @winner = "Villagers"
    elsif wolves.size >= villagers.size
      @winner = "Werewolves"
    end
    pp @winner.to_s + " have WON!!!!!!!!!!" if @winner
    @winner
  end

  def report
    [@winner, @rounds].join ','
  end

  def increment_round
    @rounds += 1
    puts
    pp "Round: #{@rounds}"
  end

  #villagers kill a player at random]
  def play_day_phase
    player_to_kill = @players.random
    @players.delete player_to_kill
    pp "DAY: Villagers kill a #{player_to_kill.class}"
  end

  #werewolves kill a villager at random
  def play_night_phase
    villager_to_kill = nil
    until villager_to_kill && villager_to_kill.is_villager? do
      villager_to_kill = @players.random
    end
    pp "NIGHT: Wolves kill a #{villager_to_kill.class}"
    @players.delete villager_to_kill
  end

end
