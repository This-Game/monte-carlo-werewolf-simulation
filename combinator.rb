require 'json'

class Combinator
  attr_accessor :results
  attr_reader :runs, :group_by_win_percentage

  def self.go(options = {})
    Combinator.new(options).run
  end

  def initialize(options = {})
    @runs = options[:runs] || 5000
    @results = {}
    @group_by_win_percentage = options[:combinator] == "win_percentage"
  end

  def run
    0.upto 24 do |v|
      1.upto 4 do |w|
        merge_results Simulator.go(:runs => runs, :villagers => v, :werewolves => w, :seers => 0, :healers => 0)
        merge_results Simulator.go(:runs => runs, :villagers => v, :werewolves => w, :seers => 1, :healers => 0)
        merge_results Simulator.go(:runs => runs, :villagers => v, :werewolves => w, :seers => 0, :healers => 1)
        merge_results Simulator.go(:runs => runs, :villagers => v, :werewolves => w, :seers => 1, :healers => 1)
      end
    end
    write!
  end


  def write!
    File.open 'site/public/results.json', 'w' do |f|
      f << results.to_json
    end
  end

  def merge_results(simulation_results)
    # We're grouping games by win percentage
    if group_by_win_percentage
      results[simulation_results.first] ||= []
      results[simulation_results.first].push(simulation_results.last)
    else # We're grouping by the makeup of the game e.g. VVVVVSWW
      results.merge! simulation_results
    end
  end
end
