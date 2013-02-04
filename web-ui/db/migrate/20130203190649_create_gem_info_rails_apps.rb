class CreateGemInfoRailsApps < ActiveRecord::Migration
  def change
    create_table :gem_info_rails_apps do |t|
      t.references :gem_info
      t.references :rails_app

      t.timestamps
    end
  end

end
