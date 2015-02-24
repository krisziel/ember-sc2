class PlayerController < ApplicationController
  helper StarcraftApi

  def save_player
    players = Player.where(bnet_id: params[:bnetid])
    if players.length == 0
      player = StarcraftApi::Player.new
      player.full_data(params[:name],params[:bnetid],params[:realm])
      save_player = Player.new(name:player.display_name,bnet_id:player.id,region:player.realm,career:player.career.to_json,season:player.season.to_json,ggsiteid:player.ggtracker.id,highest_solo:player.career["highest1v1Rank"],highest_team:player.career["highestTeamRank"],terran_level:player.swarm_levels["terran"]["level"],zerg_level:player.swarm_levels["zerg"]["level"],protoss_level:player.swarm_levels["protoss"]["level"])
      save_player.save
      id = save_player.id
    elsif ((Time.now.to_i - players[0].updated_at.to_i) > 84600)
      player = StarcraftApi::Player.new
      player.full_data(params[:name],params[:bnetid],params[:realm])
      update_player = Player.update(career:player.career.to_json,season:player.season.to_json,highest_solo:player.career["highest1v1Rank"],highest_team:player.career["highestTeamRank"],terran_level:player.swarm_levels["terran"]["level"],zerg_level:player.swarm_levels["zerg"]["level"],protoss_level:player.swarm_levels["protoss"]["level"])
      update_player.save
      id = update_player.id
    else
      id = players[0].id
    end
    profile(id)
  end

  def profile *id
    player = Player.find(params[:id] || id)[0]
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
