# encoding: UTF-8
class Villager
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

  def is_healer?
    false
  end
end

class Werewolf < Villager
  def is_werewolf?; true; end
end

class Seer < Villager
  def is_seer?; true; end
end

class Healer < Villager
  def is_healer?; true; end
end
