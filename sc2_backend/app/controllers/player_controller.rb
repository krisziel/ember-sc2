class PlayerController < ApplicationController
  helper StarcraftApi

  def index
    player = StarcraftApi::Player.new
    player.full_data("lIBARCODEIl",6117903,1)
    save_player = Player.new(name:player.display_name,bnet_id:player.id,region:player.realm,career:player.career.to_json,season:player.season.to_json,ggsiteid:player.ggtracker.id,highest_solo:player.career["highest1v1Rank"],highest_team:player.career["highestTeamRank"],terran_level:player.swarm_levels["terran"]["level"],zerg_level:player.swarm_levels["zerg"]["level"],protoss_level:player.swarm_levels["protoss"]["level"])
    save_player.save
    render json: {name:player.display_name,bnet_id:player.id,region:player.realm,career:player.career,season:player.season,ggsiteid:player.ggtracker.id,highest_solo:player.career["highest1v1Rank"],highest_team:player.career["highestTeamRank"],terran_level:player.swarm_levels["terran"]["level"],zerg_level:player.swarm_levels["zerg"]["level"],protoss_level:player.swarm_levels["protoss"]["level"]}
  end

  def profile
    player = Player.find(params[:id])
    player.career = JSON.parse(player.career)
    player.season = JSON.parse(player.season)
    player.swarm_levels = {
      :terran => player.terran_level,
      :zerg => player.zerg_level,
      :protoss => player.protoss_level
    }
    render json: player
  end
  
end
