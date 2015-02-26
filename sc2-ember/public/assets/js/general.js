var league = function(league){
  var leagues = ["bronze","silver","gold","platinum","diamond","master","grandmaster"];
  return leagues[league];
}
var rank = function(rank){
  var r = "100";
  if(rank > 50) {
    r = "100";
  } else if(rank > 25) {
    r = "50";
  } else if(rank > 8) {
    r = "25";
  } else {
    r = "8";
  }
  return "top" + r;
}
var race = {
  "p":"protoss",
  "t":"terran",
  "z":"zerg"
}
