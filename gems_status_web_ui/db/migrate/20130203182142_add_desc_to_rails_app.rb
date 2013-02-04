class AddDescToRailsApp < ActiveRecord::Migration
  def change
    add_column :rails_apps, :desc, :string
  end
end
