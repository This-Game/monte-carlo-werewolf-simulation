class Player
  attr_writer :game

  def initialize
    @role = self.class.to_s
  end

  def is_werewolf?
    false
  end

  def is_villager?
    !is_werewolf?
  end

  def is_seer?
    false
  end
end

class Werewolf < Player
  def is_werewolf?; true; end
end

class Seer < Player
  def is_seer?; true; end
end

class Healer < Player
end
