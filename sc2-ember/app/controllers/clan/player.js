import Ember from 'ember';

export default Ember.Controller.extend({
  ladderData:[],
  actions:{
    loadLadder:function(ladder){
      this.transitionToRoute('clan.player.ladder',ladder);
    }
  }
});
