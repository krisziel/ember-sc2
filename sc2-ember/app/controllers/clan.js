import Ember from 'ember';

export default Ember.Controller.extend({
  actions:{
    selectPlayer:function(player){
      console.log(player);
    }
  }
});
