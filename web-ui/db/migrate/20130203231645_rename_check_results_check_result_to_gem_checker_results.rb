class RenameCheckResultsCheckResultToGemCheckerResults < ActiveRecord::Migration
  def up
    rename_column :gem_checker_results, :check_results, :check_result
  end

  def down
  end
end
