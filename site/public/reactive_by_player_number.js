function repeat(num, string) {
  return new Array(num + 1).join(string);
}

function setUpTangle () {
  var element = $("reactive");

  var tangle = new Tangle(element, {
    initialize: function () {
      this.players = 9;
      this.werewolves = 2;
      this.seer = 0;
      this.healer = 0;
    },

    update: function () {
      this.nonWerewolves = this.players - this.werewolves;
      this.villagers = this.nonWerewolves - this.seer - this.healer;

      var resultsKey = this.players;
      var resultsForNumber = results[resultsKey];

      var goodResults = resultsForNumber.map(function(i) {
        if (i.villager_share < 30 && i.villager_share > 15) return i;
      }).clean();

      var resultsDiv = $("results").empty();
      goodResults.each(function (object, index) {
        var suggestion = new Element("div");
        var types = [];

        var letters = object.results_key.split('');
        var wolves = letters.filter(function(j){if (j == "W") return j}).length;
        var healers = letters.filter(function(j){if (j == "H") return j}).length;
        var seers = letters.filter(function(j){if (j == "S") return j}).length;

        if (wolves) {
          if (wolves.size == 1) {
            types.push("A werewolf");
          } else {
            types.push(wolves + " werewolves");
          }
        }
        if (healers) {
          types.push("a healer");
        }
        if (seers) {
          types.push("a seer");
        }
        console.log("Wolves", wolves)
        console.log("H", healers.length)
        console.log("S", seers.length)

        if (types.length > 1) {
          var text = types.slice(0, types.length - 1).join(', ') + ", and " + types.slice(-1);
        } else {
          var text = types[0];
        }
        resultsDiv.adopt(new Element("text", {text: text}));
        if (goodResults.length > 1 && index < goodResults.length - 1) {
          resultsDiv.adopt(new Element("div", {text: "OR"}));
        }
      })
      // var resultKey = repeat(this.villagers, 'V');
      // if (this.seer) resultKey += 'S';
      // if (this.healer) resultKey +='H';

      // resultKey = resultKey + repeat(this.werewolves, 'W');

      // var currentResults = results[resultKey];
      // this.win_percentage = currentResults.villager_share;
      // this.phases = currentResults.phases;
    }
  });
}