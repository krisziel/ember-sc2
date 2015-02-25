import Ember from 'ember';
import config from './config/environment';

var Router = Ember.Router.extend({
  location: config.locationType
});

Router.map(function() {
  this.resource('clan', {path:'/:tag'}, function() {
    this.route('player',{path:'/:player'});
  });
});

export default Router;
