class DropGemInfosRailsApps < ActiveRecord::Migration
  def up
   drop_table :gem_infos_rails_apps 
  end

  def down
  end
end
