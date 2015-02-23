class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :name
      t.integer :bnet_id
      t.integer :ggsiteid
      t.integer :ggtracker_id
      t.string :highest_solo
      t.string :highest_team
      t.integer :terran_level
      t.integer :protoss_level
      t.integer :zerg_level
      t.string :region
      t.timestamps
    end
  end
end
