namespace :db do
  namespace :populate do
    desc "Fill up with some data"
    task :dev => :environment do
      GemInfo.delete_all
      RailsApp.delete_all
      GemCheckerResult.delete_all
      CheckerType.delete_all
      (1..100).each do |n|
        gem_info = GemInfo.create(
          :name => "gem #{n}",
          :version => "1.1.#{n}",
          :md5sum => "abcdef123456789",
          :source => "git://github.com/gem_1",
          :gem_server => "rubygems.org",
          :license => "MIT"
        )
      end
      ('A'..'E').each do |n|
        rails_app = RailsApp.create(
          :name => "RailsApp_#{n}",
          :desc => "Desc for rails application #{n}",
          :gemfile => "git://github.com/RailsApp_#{n}/Gemfile"
        )     
      end
      RailsApp.find_by_name("RailsApp_A").gem_infos = GemInfo.all
      CheckerType.create(:name => "is_native", :desc => "desc 1")
      CheckerType.create(:name => "is_rubygems.org", :desc => "desc 2")
      CheckerType.create(:name => "is_latest_version", :desc => "desc 2")
      CheckerType.create(:name => "has_security_alerts", :desc => "desc 2")
      CheckerType.create(:name => "has_changed", :desc => "desc 2")
      CheckerType.create(:name => "has_license", :desc => "desc 2")
      CheckerType.create(:name => "is_GPL_compatible", :desc => "desc 2")
      gc = GemCheckerResult.create(
        :check_result => "yes",
      )
      gc.checker_type = CheckerType.find_by_name("has_license")
      gc.save
      gc = GemCheckerResult.create(
        :check_result => "no",
      )
      gc.checker_type = CheckerType.find_by_name("is_rubygems.org")
      gc.save
      GemInfo.find_by_name("gem 1").gem_checker_results = GemCheckerResult.all
    end
  end
end
