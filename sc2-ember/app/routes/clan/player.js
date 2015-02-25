import Ember from 'ember';

export default Ember.Route.extend({
  model:function(params){
    return params;
  },
  setupController: function (controller, model) {
    var rank = function(rank){
      var r = "100";
      if(rank > 50) {
        r = "100";
      } else if(rank > 25) {
        r = "50";
      } else if(rank > 8) {
        r = "25";
      } else {
        r = "8";
      }
      return "top" + r;
    }
    var league = function(league){
      var leagues = ["bronze","silver","gold","platinum","diamond","master","grandmaster"];
      return leagues[league];
    }
    controller.set('model', model);
    var params = this.get('controller.model');
    $('.player-row').removeClass('active');
    $('.player-row[name="' + params.player.toLowerCase() + '"]').addClass('active');
    setTimeout(function(){ $('.player-window').css({display:'inherit'}); },500);
    var max = $(window).innerHeight()-160;
    $('#memberList').css({maxHeight:max});
    $('#memberColumn').addClass('left');
    var player;
    $.each(this.modelFor('clan').players,function(i,p){
      if(p.name.toLowerCase() == params.player.toLowerCase()) {
        player = p;
      }
      p.ggplayer.top = [
        {
          league:league(p.ggplayer.solo_league),
          rank_range:rank(p.ggplayer.solo_rank),
          rank:p.ggplayer.solo_rank,
          type:"1v1"
        },
        {
          league:league(p.ggplayer.twos_league),
          rank_range:rank(p.ggplayer.twos_rank),
          rank:p.ggplayer.twos_rank,
          type:"2v2"
        },
        {
          league:league(p.ggplayer.threes_league),
          rank_range:rank(p.ggplayer.threes_rank),
          rank:p.ggplayer.threes_rank,
          type:"3v3"
        },
        {
          league:league(p.ggplayer.fours_league),
          rank_range:rank(p.ggplayer.fours_rank),
          rank:p.ggplayer.fours_rank,
          type:"4v4"
        }
      ]
    });
    player.clanTag = this.modelFor('clan').tag
    this.set('controller.model',player);
  }
});
