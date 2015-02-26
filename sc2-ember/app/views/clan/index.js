import Ember from 'ember';

export default Ember.View.extend({
  didInsertElement: function(){
    height = ($(window).height() - 170);
    $('#memberColumn').css({maxHeight:height});
    $('.player-window').css({maxHeight:height});
  }
});
