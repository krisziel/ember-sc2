import Ember from 'ember';

export default Ember.Route.extend({
  model:function(params){
    return Ember.$.getJSON('http://localhost:3000/clan/' + params.tag).then(function(response){
      var league = function(league){
        var leagues = ["grandmaster","master","diamond","platinum","gold","silver","bronze"];
        return leagues[league];
      }
      var rank = function(rank){
        var r = "100";
        if(rank > 25) {
          r = "50";
        } else if(rank > 8) {
          r = "25";
        } else {
          r = "8";
        }
        return "top" + r;
      }
      var race = {
        "p":"protoss",
        "t":"terran",
        "z":"zerg"
      }
      var players = response.clan[2];
      $.each(players,function(i,player){
        player['ggplayer']['most_played_race'] = race[player['ggplayer']['most_played_race']];
        player['highest_league_type'] = league(player.ggplayer.highest_league_type);
        player['highest_league_rank'] = rank(player.ggplayer.highest_league_rank);
      });
      return {
        tag:response.clan[0],
        name:response.clan[1],
        players:players
      };
    });
  }
});
