class Array

  def take_random
    i = rand size
    self[i]
  end

end

class Player
  attr_writer :game

  def initialize
    @role = self.class.to_s
  end

  # def draw_card
  #   @game.restock if @game.draw.empty?
  #   c = @game.draw.pop
  #   @hand << c
  # end

  def is_werewolf?
    false
  end

  def is_villager?
    !is_werewolf?
  end

  def select_playable_cards

    @hand.select do |c|
      top = @game.top_card

      if @game.draw_amount > 0
        [:plus2, :plus4].include? c.value
      elsif c.wild?
        true
      elsif c.color == top.color
        true
      elsif c.value == top.value
        true
      else
        false
      end

    end

  end

  def can_play?
    @playable_cards = select_playable_cards
    @playable_cards.any?
  end

  def play_card
    c = choose_card
    @hand.delete c
    c.color = choose_color if c.wild?
    @game.discard.push c
    @game.set_next_action
    @playable_cards = []
  end

  def choose_color
    Card::COLORS.take_random
  end

  def choose_card
    @playable_cards.take_random
  end

end

class Werewolf < Player

  def is_werewolf?
    true
  end

  def choose_color

    if @hand.empty?
      super
    else
      h = Hash.new { |h,k| h[k] = 0 }
      @hand.each { |c| h[c.color] += 1 }
      h.sort { |(a_c, a_v),(b_c, b_v)| a_v <=> b_v }.last[0]
    end

  end

end

class Healer < Player

  def choose_card
    @playable_cards.find { |c| c.value == :plus4 } or
    @playable_cards.find { |c| c.value == :plus2 } or
    super
  end

end

class Seer < Player

  def choose_card

    if @playable_cards.any? { |c| [:plus2, :plus4].include? c.value }

      cs = @playable_cards.sort_by do |c|

        case c.value
        when :plus2 then 1.0
        when :plus4 then 2.0
        else rand
        end

      end

      cs.first
    else
      super
    end

  end

end
