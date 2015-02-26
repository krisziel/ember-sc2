import Ember from 'ember';

export default Ember.Controller.extend({
  clanTag:"",
  actions:{
    searchClans:function(){
      var _this = this;
      if($('#searchClanButton').html() == 'Save Clan') {
        Ember.$.getJSON('http://localhost:3000/clan/' + _this.get('clanTag') + '/add').then(function(response){
          if(response.error) {
            $('#searchClanButton').removeClass('blue').addClass('green').html('Save Clan');
            $('.clan-search input').on('change',function(){ $('#searchClanButton').removeClass('green').addClass('blue').html('Search for Clan') })
          } else if(response.tag) {
            _this.transitionToRoute('clan',response.tag)
          }
        });
      } else {
        Ember.$.getJSON('http://localhost:3000/clan/' + _this.get('clanTag')).then(function(response){
          if(response.error) {
            $('#searchClanButton').removeClass('blue').addClass('green').html('Save Clan');
            $('.clan-search input').on('change',function(){ $('#searchClanButton').removeClass('green').addClass('blue').html('Search for Clan') })
          } else if(response.clan) {
            _this.transitionToRoute('clan',response.clan[0])
          }
        });
      }
    }
  }
});
