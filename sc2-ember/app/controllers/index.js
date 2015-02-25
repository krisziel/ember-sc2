import Ember from 'ember';

export default Ember.Controller.extend({
  clanTag:"",
  actions:{
    searchClans:function(){
      var _this = this;
      Ember.$.getJSON('http://localhost:3000/clan/' + this.get('clanTag')).then(function(response){
        if(response.error) {
          $('#searchClanButton').removeClass('blue').addClass('green').html('Save Clan');
          $('.clan-search input').on('change',function(){ $('#searchClanButton').removeClass('green').addClass('blue').html('Search for Clan') })
        } else if(response.clan) {
          _this.transitionToRoute('clan',response.clan.tag)
        }
      });
    }
  }
});
