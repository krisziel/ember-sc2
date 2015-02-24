module StarcraftApi

  class StarcraftPlayer
    attr_reader :id, :realm, :display_name, :clan_name, :clan_tag, :profile_path, :portrait, :career, :season, :campaign, :swarm_levels, :rewards, :achievements, :ladders, :ggtracker

    def basic_data data
      @id = data['id']
      @display_name = data['displayName']
      @realm = data['realm']
      @clan_name = data['clanName']
      @clan_tag = data['clanTag']
      @profile_path = data['profilePath']
    end

    def full_data(name, id, realm, *url)
      data = JSON.parse(RestClient.get("https://us.api.battle.net/sc2/profile/#{id}/#{realm}/#{name}/?locale=en_US&apikey=u6asyvg57kuru6gbsu37wxbmfd4djv9y").body)
      ggtracker = StarcraftApi::StarcraftGGTracker.new.save_player(name, id, realm)
      @display_name = data['displayName']
      @id = data['id']
      @realm = data['realm']
      @clan_name = data['clanName']
      @clan_tag = data['clanTag']
      @profile_path = data['profilePath']
      @portrait = data['portrait']
      @career = data['career']
      @season = data['season']
      @campaign = data['campaign']
      @swarm_levels = data['swarmLevels']
      @rewards = data['rewards']
      @achievements = data['achievements']
      @ggtracker = ggtracker.id
      @ladders = nil
    end

    def save_player(name, bnetid, realm)
      players = Player.where(bnet_id: bnetid)
      if players.length == 0
        full_data(name,bnetid,realm)
        ggplayer = Ggplayer.where(bnetid:bnetid)[0]
        save_player = Player.new(ggplayer_id:ggtracker,name:@display_name,bnet_id:@id,region:@realm,career:@career.to_json,season:@season.to_json,highest_solo:@career["highest1v1Rank"],highest_team:@career["highestTeamRank"],terran_level:@swarm_levels["terran"]["level"],zerg_level:@swarm_levels["zerg"]["level"],protoss_level:@swarm_levels["protoss"]["level"])
        save_player.save
        player = save_player
        ggplayer.update(player_id:player.id)
      elsif ((Time.now.to_i - players[0].updated_at.to_i) > 84600)
        full_data(name,bnetid,realm)
        ggplayer = Ggplayer.where(bnetid:bnetid)[0]
        player = players[0]
        update_player = player.update(ggplayer_id:ggtracker,career:@career.to_json,season:@season.to_json,highest_solo:@career["highest1v1Rank"],highest_team:@career["highestTeamRank"],terran_level:@swarm_levels["terran"]["level"],zerg_level:@swarm_levels["zerg"]["level"],protoss_level:@swarm_levels["protoss"]["level"])
        update_player.save
        player = update_player
        ggplayer.update(player_id:player.id)
      else
        player = players[0]
      end
      identity = {
        :name => player.name,
        :bnet_id => player.bnet_id,
        :realm => player.region,
        :id => player.id
      }
      identity
    end

  end

  class StarcraftGGTracker
    attr_accessor :leagues, :id, :name, :gateway, :matches_count, :hours_players, :race, :league_highest, :league_1v1, :league_2v2, :league_3v3, :league_4v4, :points, :season_games, :career_games, :apm
    @leagues = {
      0 => "bronze",
      1 => "silver",
      2 => "gold",
      3 => "platinum",
      4 => "diamond",
      5 => "master",
      6 => "grandmaster"
    }

    def ggid id
      data = JSON.parse(RestClient.get("http://api.ggtracker.com/api/v1/identities/#{id}.json"))
      data
      if data['name']
        gg_profile = get_identity data
      end
      gg_profile
    end

    def bnet(name, id, realm)
      data = JSON.parse(RestClient.get("http://api.ggtracker.com/api/v1/identities/find.json?profile_url=http://us.battle.net/sc2/en/profile/#{id}/#{realm}/#{name}/").body)
      data
    end

    def get_identity data
      @leagues = ["bronze","silver","gold","platinum","diamond","master","grandmaster"]
      @id = data['id']
      @name = data['name']
      @gateway = data['gateway']
      @matches_count = data['matches_count']
      @hours_played = data['hours_played'].round
      @race = data['most_played_race']
      if data['current_highest_type']
        @league_highest = {
          :type => data['current_highest_type'],
          :league => @leagues[data['current_highest_league']],
          :rank => data['current_highest_leaguerank']
        }
      end
      if data['current_league_1v1']
        @league_1v1 = {
          :league => @leagues[data['current_league_1v1']],
          :rank => data['current_rank_1v1']
        }
      end
      if data['current_league_2v2']
        @league_2v2 = {
          :league => @leagues[data['current_league_2v2']],
          :rank => data['current_rank_2v2']
        }
      end
      if data['current_league_3v3']
        @league_3v3 = {
          :league => @leagues[data['current_league_3v3']],
          :rank => data['current_rank_3v3']
        }
      end
      if data['current_league_4v4']
        @league_4v4 = {
          :league => @leagues[data['current_league_4v4']],
          :rank => data['current_rank_4v4']
        }
      end
      @points = data['achievement_points']
      @season_games = data['season_games']
      @career_games = data['career_games']
      @apm = data['stats']['apm']['avg'].round
    end

    def save_player(name, id, realm)
      data = StarcraftApi::StarcraftGGTracker.new.bnet(name, id, realm)
      gg_data = {
        :ggsiteid => data['id'],
        :matches_count => data['matches_count'],
        :hours_played => data['hours_played'],
        :most_played_race => data['most_played_race'],
        :highest_league_type => data['current_highest_type'],
        :highest_league_rank => data['current_highest_leaguerank'],
        :solo_league => data['current_league_1v1'],
        :solo_rank => data['current_rank_1v1'],
        :twos_league => data['current_league_2v2'],
        :twos_rank => data['current_rank_2v2'],
        :threes_league => data['current_league_3v3'],
        :threes_rank => data['current_rank_3v3'],
        :fours_league => data['current_league_4v4'],
        :fours_rank => data['current_rank_4v4'],
        :achievement_points => data['achievement_points'],
        :season_games => data['season_games'],
        :career_games => data['career_games'],
        :apm => data['stats']['apm']['avg'].round,
        :bnetid => id
      }
      if Ggplayer.where(bnetid: id).length == 1
        player = Ggplayer.where(bnetid:id)[0]
        player.update(gg_data)
        player.save
      else
        player = Ggplayer.new(gg_data)
        player.save
      end
      player
    end

  end

end
