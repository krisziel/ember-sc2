class Player < ActiveRecord::Base
  attr_accessor :swarm_levels, :ggplayer

  belongs_to :clan
  has_one :ggplayer
  has_many :teams, through: :team_members
end
