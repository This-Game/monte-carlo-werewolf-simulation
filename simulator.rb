class Simulator
  attr_accessor :runs, :hist, :rounds, :phases, :game, :player_classes, :results_key

  def initialize(options)
    self.runs = options[:runs]
    self.hist = {}
    self.game = nil
    self.rounds = 0
    self.phases = 0

    self.player_classes = options[:villagers].times.collect{ Villager } +
                          options[:seers].times.collect{ Seer } +
                          options[:healers].times.collect{ Healer } +
                          options[:werewolves].times.collect{ Werewolf }
    self.results_key = player_classes.collect {|c| c.to_s[0,1]}.join
  end

  def go
    runs.times do
      game = WerewolfGame.new
      self.player_classes.each { |_class| game.players << _class.new }

      until game.done?
        game.increment_round

        # Day first, then Night. Swap these for weirdoes who play starting with a nighttime killing phase.
        game.play_night_phase
        break if game.done?
        game.play_day_phase
      end

      if game.winner
        hist[game.winner] ||= 0
        hist[game.winner] += 1
      end

      self.rounds += game.rounds
      self.phases += game.phases
    end

    villager_share = 0
    # puts results_key
    hist.keys.sort.each do |player_type|
      wins  = hist[player_type]
      share = (wins.to_f / runs) * 100

      if player_type == 'Villagers'
        # puts "V |" + ("#" * share.to_i) +  ("–" * (100 - share).to_i) + "| W"
        villager_share = share.to_i
      end
      # puts "#{player_type}: #{wins} wins, #{share.round()}%"
    end

    # puts
    # puts "avg rounds: #{ rounds.to_f / runs.to_f }"
    # puts "avg phases: #{ phases.to_f / runs.to_f }"
    # puts
    {results_key => {
      :villager_share => villager_share,
      :rounds => rounds.to_f / runs.to_f,
      :phases => phases.to_f / runs.to_f }
    }

  end
end