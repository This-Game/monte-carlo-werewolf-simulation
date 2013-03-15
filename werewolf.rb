require_relative 'player'

class Werewolf
  attr_reader :rounds, :winner, :players

  def initialize
    @players = []
    # @draw = Card.deck.sort_by { rand }
    # @discard = []

    # action
    @action = nil
    @done = false

    # stats
    @rounds = 0
    @restocks = 0
    @winner = nil
    @runout = false
  end

  def done?
    wolves, villagers = @players.partition {|player| player.is_werewolf? }
    if wolves.empty?
      @winner = "Villagers"
    elsif wolves.size >= villagers.size
      @winner = "Werewolves"
    end
    # pp @winner.to_s + " have WON!!!!!!!!!!" if @winner
    @winner
  end

  def report
    [@winner, @rounds].join ','
  end


  def set_next_action

    case top_card.value
    when :plus4
      @action = :draw
      @draw_amount += 4

    when :plus2
      @action = :draw
      @draw_amount += 2

    when :skip
      @action = :skip

    when :reverse
      @action = :reverse

    else
      reset_action
    end

  end

  def reset_action
    @action = nil
    @draw_amount = 0
  end

  def play_round
    @rounds += 1
    # pp "Round #{rounds}. Players: #{@players.size}"
    #villagers lynch a player at random
    killed_player = @players.random_pop
    # pp "Villagers killed a #{killed_player.class}",

    #werewolves kill a villager at random
    until villager = @players.random.is_villager? do
      @players.delete villager
      # pp "Wolves kill a villager "
    end
  end

end
