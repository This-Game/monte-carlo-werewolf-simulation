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

end

class Werewolf < Player
  def is_werewolf?
    true
  end
end

class Healer < Player
end

class Seer < Player
end
