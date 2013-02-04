class CreateGemInfosRailsApps < ActiveRecord::Migration
  def change
    create_table :gem_infos_rails_apps do |t|
      t.references :gem_info
      t.references :rails_app

      t.timestamps
    end
  end
end
