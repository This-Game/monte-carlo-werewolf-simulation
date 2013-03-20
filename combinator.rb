require 'json'

runs = 5000
results = {}

3.upto(20) do |v|
  1.upto(4) do |w|
    results.merge! Simulator.new(:runs => runs, :villagers => v, :werewolves => w, :seers => 0, :healers => 0).go
    results.merge! Simulator.new(:runs => runs, :villagers => v, :werewolves => w, :seers => 1, :healers => 0).go
    results.merge! Simulator.new(:runs => runs, :villagers => v, :werewolves => w, :seers => 0, :healers => 1).go
    results.merge! Simulator.new(:runs => runs, :villagers => v, :werewolves => w, :seers => 1, :healers => 1).go
  end
end

File.open 'results.json', 'w' do |f|
  f << results.to_json
end