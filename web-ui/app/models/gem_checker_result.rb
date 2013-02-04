class GemCheckerResult < ActiveRecord::Base
  attr_accessible :desc, :name, :check_result
  validates :check_result, :presence => true
  belongs_to :gem_info
  belongs_to :checker_type
end
