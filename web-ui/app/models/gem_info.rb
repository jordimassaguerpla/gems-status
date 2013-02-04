class GemInfo < ActiveRecord::Base
  attr_accessible :gem_server, :md5sum, :name, :source, :version, :license
  validates :gem_server,  :presence => true
  validates :md5sum,      :presence => true
  validates :name,        :presence => true
  validates :source,      :presence => true
  validates :version,     :presence => true
  has_many :gem_infos_rails_apps
  has_many :rails_apps, :through => :gem_infos_rails_apps
  has_many :gem_checker_results
end
