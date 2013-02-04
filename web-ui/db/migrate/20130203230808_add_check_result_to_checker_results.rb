class AddCheckResultToCheckerResults < ActiveRecord::Migration
  def change
    add_column :gem_checker_results, :check_results, :string
  end
end
