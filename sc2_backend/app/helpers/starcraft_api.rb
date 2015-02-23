module StarcraftApi

  class Player
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
      ggtracker = StarcraftApi::GGTracker.new
      gg_profile = ggtracker.ggid 1572848
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
      @ggtracker = ggtracker
      @ladders = nil
    end
  end
  # Player.new(name:player.display_name,bnet_id:player.id,region:player.realm,career:player.career,season:player.season,ggsiteid:player.ggtracker.id,highest_solo:player.career.highest1v1Rank,highest_team:player.career.highestTeamRank,terran_level:player.swarmLevels["terran"]["level"],zerg_level:player.swarmLevels["zerg"]["level"],protoss_level:player.swarmLevels["protoss"]["level"])

  class GGTracker
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
      if data['name']
        gg_profile = get_identity data
      end
      gg_profile
    end

    def bnet(name, id, realm)
      p "http://us.battle.net/sc2/en/profile/#{id}/#{realm}/#{name}/"
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
          :rank => data['current_highest_type']
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

  end

end
