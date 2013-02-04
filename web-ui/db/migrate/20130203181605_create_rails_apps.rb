class CreateRailsApps < ActiveRecord::Migration
  def change
    create_table :rails_apps do |t|
      t.string :name
      t.string :gemfile

      t.timestamps
    end
  end
end
