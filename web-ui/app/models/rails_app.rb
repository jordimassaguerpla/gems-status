class RailsApp < ActiveRecord::Base
  attr_accessible :gemfile, :name, :desc
  validates :gemfile, :presence => true
  validates :name,    :presence => true
  validates :desc,    :presence => true
  has_many :gem_info_rails_app
  has_many :gem_infos, :through => :gem_info_rails_app
end
