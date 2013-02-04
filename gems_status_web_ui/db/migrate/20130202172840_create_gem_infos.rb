class CreateGemInfos < ActiveRecord::Migration
  def change
    create_table :gem_infos do |t|
      t.string :name
      t.string :version
      t.string :md5sum
      t.string :source
      t.string :gem_server

      t.timestamps
    end
  end
end
