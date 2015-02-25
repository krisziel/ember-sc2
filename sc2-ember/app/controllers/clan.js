import Ember from 'ember';

export default Ember.Controller.extend({
  actions:{
    selectPlayer:function(player){
      this.transitionToRoute('clan.player', player.name);
      $('.player-row').removeClass('active');
      $('.player-row[name="' + player.name.toLowerCase() + '"]').addClass('active');
      $('#memberColumn').addClass('left');
      setTimeout(function(){ $('.player-window').css({display:'inherit'}); },500);
    }
  }
});
