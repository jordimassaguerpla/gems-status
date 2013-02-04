class RefactorCheckerResult < ActiveRecord::Migration
  def up
    remove_column :gem_checker_results, :name
    remove_column :gem_checker_results, :desc
    add_column :gem_checker_results, :checker_type_id, :intenger
  end

  def down
  end
end
