function repeat(num, string) {
  return new Array(num + 1).join(string);
}

function setUpTangle () {
  var element = document.getElementById("reactive");

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

      var resultKey = repeat(this.villagers, 'V');
      if (this.seer) resultKey += 'S';
      if (this.healer) resultKey +='H';

      resultKey = resultKey + repeat(this.werewolves, 'W');

      var currentResults = results[resultKey];
      this.win_percentage = currentResults.villager_share;
      this.phases = currentResults.phases;
    }
  });
}