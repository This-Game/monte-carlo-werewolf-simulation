require_relative 'player'

class WerewolfGame
  attr_reader :rounds, :winner, :players, :cleared_players

  def initialize
    @players = []
    @cleared_players = []

    # stats
    @rounds = 0
    @winner = nil
  end

  def log string
    pp string if ARGV[0]
  end

  def suspected_players
    @players - @cleared_players
  end

  def done?
    wolves, villagers = @players.partition {|player| player.is_werewolf? }
    if wolves.empty?
      @winner = "Villagers"
    elsif wolves.size >= villagers.size
      @winner = "Werewolves"
    end
    log @winner.to_s + " have WON!!!!!!!!!!" if @winner
    @winner
  end

  def report
    [@winner, @rounds].join ','
  end

  def increment_round
    @rounds += 1
    log "Round: #{@rounds}"
  end

  #villagers kill a player at random]
  def play_day_phase
    player_to_kill = if @players.any? {|player| player.is_seer? }
      seen_player = suspected_players.random
      if seen_player.is_werewolf?
        log "DAY: Seer sees a wolf"
        seen_player
      else
        log "DAY: Seer clears a villager"
        @cleared_players << seen_player
        suspected_players.random
      end
    else
      suspected_players.random
    end

    log "DAY: Villagers kill a #{player_to_kill.class}"
    @players.delete player_to_kill
  end

  #werewolves kill a villager at random
  def play_night_phase
    villager_to_kill = nil
    until villager_to_kill && villager_to_kill.is_villager? do
      villager_to_kill = @players.random
    end
    log "NIGHT: Wolves kill a #{villager_to_kill.class}"
    @players.delete villager_to_kill
  end

end
