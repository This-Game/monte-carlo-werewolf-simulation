# encoding: UTF-8
require 'json'

class Combinator
  attr_accessor :results
  attr_reader :runs, :group_by, :options

  def self.go(options = {})
    Combinator.new(options).run
  end

  def initialize(options = {})
    @options = options
    @results = {}
    @group_by =  options[:combinator]
  end

  def run
    0.upto 24 do |v|
      1.upto 4 do |w|
        common = {:villagers => v, :werewolves => w, :runs => options[:runs], :combinator => options[:combinator]}
        merge_results Simulator.go({:seers => 0, :healers => 0}.merge!(common))
        merge_results Simulator.go({:seers => 1, :healers => 0}.merge!(common))
        merge_results Simulator.go({:seers => 0, :healers => 1}.merge!(common))
        merge_results Simulator.go({:seers => 1, :healers => 1}.merge!(common))
      end
    end
    write!
  end


  def write!
    File.open "site/public/#{options[:combinator]}.json", 'w' do |file|
      file << results.to_json
    end
  end

  def merge_results(simulation_results)
    if group_by == "player_number"
      # We're grouping games by win percentage
      results[simulation_results.first] ||= []
      results[simulation_results.first].push(simulation_results.last)
    else
      # We're grouping by the makeup of the game e.g. VVVVVSWW
      results.merge! simulation_results.last
    end
  end
end
