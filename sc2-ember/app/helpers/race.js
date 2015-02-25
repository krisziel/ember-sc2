import Ember from "ember"

export default Ember.Handlebars.makeBoundHelper(function(value, options) {
  var races = {
    "p":"Protoss",
    "z":"Zerg",
    "t":"Terran"
  }
  return races[value];
});
