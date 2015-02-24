class PlayerController < ApplicationController
  helper StarcraftApi

  def save_player
    identity = StarcraftApi::StarcraftPlayer.new.save_player(params[:name],params[:bnetid],params[:realm])
    profile(identity[:id])
    # StarcraftApi::GGTracker.save_player(itentity)
  end

  def profile *id
    player = Player.find(params[:id] || id)
    player = player[0] if player.class == Array
    player.career = JSON.parse(player.career)
    player.season = JSON.parse(player.season)
    player.swarm_levels = {
      :terran => player.terran_level,
      :zerg => player.zerg_level,
      :protoss => player.protoss_level
    }
    player.ggplayer = Ggplayer.find(player.ggplayer_id)
    render json: player
  end

end
