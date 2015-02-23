class Player < ActiveRecord::Base
  belongs_to :clan
  has_many :teams, through: :team_members

  attr_accessor :swarm_levels
  
end
