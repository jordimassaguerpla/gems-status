class DropColumnCheckerResultToCheckerResults < ActiveRecord::Migration
  def up
    remove_column :gem_checker_results, :checker_result
  end

  def down
  end
end
