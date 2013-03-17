require_relative 'player'

class WerewolfGame
  attr_reader :rounds, :phases, :winner, :players, :cleared_players

  def initialize
    @players = []
    @cleared_players = []

    # stats
    @rounds = 0
    @phases = 0
    @winner = nil
  end

  def log string
    pp string if ARGV[0] == 'debug'
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
    log "Round: #{@rounds}"
    @rounds += 1
  end

  def increment_phase
    @phases += 1
  end

  # Villagers kill a player at random
  # in this sim, if there is a Seer and that person randomly sees a Werewolf, the village immediately kills the wolf.
  # Otherwise, they will put the player in a "cleared" list, and the village will not kill cleared players in the future.
  # Unrealistically, the Werewolves will not single out the Seer for death; they still kill at random.
  def play_day_phase
    increment_phase

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
    increment_phase
    villager_to_kill = @players.reject {|player| player.is_werewolf? }.random

    # healer picks someone at random, is ignorant of seer's cleared list
    if @players.any? { |player| player.is_healer? } && villager_to_kill == @players.random
      log "NIGHT: Wolves kill nobody; the #{villager_to_kill.class} was healed"
    else
      log "NIGHT: Wolves kill a #{villager_to_kill.class}"
      @players.delete villager_to_kill
    end
  end

end
