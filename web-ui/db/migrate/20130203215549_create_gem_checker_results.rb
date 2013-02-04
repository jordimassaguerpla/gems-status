class CreateGemCheckerResults < ActiveRecord::Migration
  def change
    create_table :gem_checker_results do |t|
      t.string :name
      t.boolean :result
      t.string :desc
      t.references :gem_info

      t.timestamps
    end
  end
end
