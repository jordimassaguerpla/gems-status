class GemInfoRailsApp < ActiveRecord::Base
  belongs_to :gem_info
  belongs_to :rails_app
end
