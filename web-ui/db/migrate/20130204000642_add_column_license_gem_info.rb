class AddColumnLicenseGemInfo < ActiveRecord::Migration
  def up
    add_column :gem_infos, :license, :string
  end

  def down
  end
end
