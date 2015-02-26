import Ember from 'ember';

export default Ember.Route.extend({
  model:function(params){
    var _this = this;
    return Ember.$.getJSON('http://localhost:3000/middleman/?url=https://us.api.battle.net/sc2/ladder/' + params.ladder_id + '?locale=en_US&apikey=u6asyvg57kuru6gbsu37wxbmfd4djv9y',function(ladderData){
      var ladderList = [];
      _this.controllerFor('clan.player').set('ladderData',ladderData.ladderMembers);
      // Ember.$(response,function(i,ladder){
      //   ladderList.push(parseLadder(ladder));
      // });
      // console.log(ladderList);
      // return ladderList;
      return ladderData;
    });
  }
});
