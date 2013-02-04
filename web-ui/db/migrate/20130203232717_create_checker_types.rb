class CreateCheckerTypes < ActiveRecord::Migration
  def change
    create_table :checker_types do |t|
      t.string :name
      t.string :desc

      t.timestamps
    end
  end
end
