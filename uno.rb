require_relative 'card'
require_relative 'player'

class RunOut < StandardError; end

class Uno
  attr_reader :rounds, :winner, :restocks, :runout
  attr_reader :discard, :draw, :draw_amount, :players

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
    pp @winner.to_s + " have WON!!!!!!!!!!" if @winner
    @winner
  end

  def deal
    @players.each { |p| p.game = self }

    unless (2..10).include? @players.size
      raise "wrong amount of players: #{@players.size}"
    end

    # 7.times { @players.each { |p| p.draw_card } }
    @discard.push @draw.pop
  end

  def report
    [@winner, @rounds, @restocks].join ','
  end

  def top_card
    @discard.last
  end

  def restock
    @restocks += 1
    top = @discard.pop
    raise RunOut if @discard.empty?
    @draw = @discard.sort_by { rand }
    @discard = [top]
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

    begin
      pp "Round #{rounds}. Players: #{@players.size}"
      #villagers lynch a player at random
      killed_player = @players.random_pop
      pp "Villagers killed a #{killed_player.class}",

      #werewolves kill a villager at random
      until villager = @players.random.is_villager? do
        @players.delete villager
        pp "Wolves kill a villager "
      end

    rescue RunOut => e
      @runout = true
    end

  end

end
