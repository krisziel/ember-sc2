class PlayerSerializer < ActiveModel::Serializer
  attributes :id, :name, :bnet_id, :region, :season, :career, :ggsiteid, :swarm_levels, :ggplayer
end
