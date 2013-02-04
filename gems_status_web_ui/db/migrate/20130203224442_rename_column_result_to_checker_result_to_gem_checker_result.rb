class RenameColumnResultToCheckerResultToGemCheckerResult < ActiveRecord::Migration
  def up
    rename_column :gem_checker_results, :result, :checker_result
  end

  def down
  end
end
