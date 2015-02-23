class AddStatsToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :career, :string
    add_column :players, :season, :string
  end
end
