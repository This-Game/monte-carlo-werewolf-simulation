Monte Carlo Werewolf Simulation
==========================

Simulate the game of [Werewolf](http://thisgame.co/newsletters/an-informed-minority) with different roles and player ratios.

To run the simulation:

    `ruby simulate.rb`

To start hacking on this, by look at `simulate.rb` and play with the simulations at the bottom of the file. To log the progression of an individual game, pass a second arg fromt he command line, e.g.

    `ruby simulate.rb debug`

I recommend taking the runs down to 1 when checking individual game runs for correctness. Code layout borrowed from flazz's [Uno sim](https://github.com/flazz/monte-carlo-uno-simulation).
