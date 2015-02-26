import Ember from 'ember';

export default Ember.Route.extend({
  model:function(params){
    return params;
  },
  ladders:function(){

  },
  setupController: function (controller, model) {
    var _this = this;
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
    };
    var league = function(league){
      var leagues = ["bronze","silver","gold","platinum","diamond","master","grandmaster"];
      return leagues[league];
    };
    controller.set('model', model);
    var params = this.get('controller.model');
    Ember.$('.player-row').removeClass('active');
    Ember.$('.player-row[name="' + params.player.toLowerCase() + '"]').addClass('active');
    setTimeout(function(){ Ember.$('.player-window').css({display:'inherit'}); },500);
    var max = Ember.$(window).innerHeight()-160;
    Ember.$('#memberList').css({maxHeight:max});
    Ember.$('#memberColumn').addClass('left');
    var player;
    Ember.$.each(this.modelFor('clan').players,function(i,p){
      if(p.name.toLowerCase() === params.player.toLowerCase()) {
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
      ];
    });
    player.clanTag = this.modelFor('clan').tag;
    this.set('controller.model',player);
    Ember.$.getJSON('http://localhost:3000/middleman/?url=https://us.api.battle.net/sc2/profile/' + player.bnet_id + '/' + player.region + '/' + player.name + '/ladders?locale=en_US&apikey=u6asyvg57kuru6gbsu37wxbmfd4djv9y',function(response){
      var ladderData = {
        HOTS:[[],[],[],[]],
        WOL:[[],[],[],[]]
      };
      Ember.$.each(response.currentSeason,function(i,ladder){
        if(ladder.ladder.length > 0) {
          var characters = [];
          Ember.$.each(ladder.characters,function(i, char){
            characters.push(char.displayName);
          });
          Ember.$.each(ladder.ladder,function(i,random_ladder){
            var type = "";
            var mmq = random_ladder.matchMakingQueue;
            var insertIndex = 0;
            if(mmq.match("TWOS")) {
              insertIndex = 1;
              if(characters.length === 2) {
                type = "2v2 Arranged";
              } else {
                type = "2v2 Random";
              }
            } else if(mmq.match("THREES")) {
              insertIndex = 2;
              if(characters.length === 3) {
                type = "3v3 Arranged";
              } else {
                type = "3v3 Random";
              }
            } else if(mmq.match("FOURS")) {
              insertIndex = 3;
              if(characters.length === 4) {
                type = "4v4 Arranged";
              } else {
                type = "4v4 Random";
              }
            } else {
              insertIndex = 0;
              type = "1v1";
            }
            var expansion = "";
            var info = random_ladder;
            if(random_ladder.matchMakingQueue.substring(0,4) === "HOTS") {
              expansion = "HOTS";
            } else {
              expansion = "WOL";
            }
            var ladderInfo = {
              name:info.ladderName,
              id:info.ladderId,
              rank:info.rank,
              league:info.league.toLowerCase(),
              type:type,
              wins:info.wins,
              losses:info.losses,
              expansion:expansion,
              rankRange:rank(info.rank)
            }
            var thisLadder = {
              ladder:ladderInfo,
              characters:{
                string:characters.join(", "),
                list:ladder.characters
              }
            }
            ladderData[expansion][insertIndex].push(thisLadder);
          });
        }
      });
      var wol = []
      wol = wol.concat.apply(wol, ladderData["WOL"]);
      var hots = []
      hots = hots.concat.apply(hots, ladderData["HOTS"]);
      ladderData = {
        "WOL":wol,
        "HOTS":hots
      }
      _this.set('controller.ladders',ladderData);
    });
  }
});
