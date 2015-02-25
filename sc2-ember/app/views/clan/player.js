import Ember from 'ember';

export default Ember.View.extend({
  didInsertElement: function(){
    console.log("RORY SUCH BEAUTY");
    var params = this.get('controller.model');
    $('.player-row').removeClass('active');
    $('.player-row[name="' + params.player.toLowerCase() + '"]').addClass('active');
    $('#memberColumn').addClass('left');
    var max = $(window).innerHeight()-160;
    $('#memberList').css({maxHeight:max});
  }
});
