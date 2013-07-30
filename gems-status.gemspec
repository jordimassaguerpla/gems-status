$LOAD_PATH.unshift 'lib'
require 'gems-status/gems_status_metadata'

Gem::Specification.new do |s|
  s.name     = "gems-status"
  s.version  = GemsStatus::VERSION
  s.date     = Time.now.strftime('%F')
  s.summary  = "gem-status gets the list of gems you use from Gemfile.lock file and runs some checks on those gems."
  s.homepage = "http://github.com/jordimassaguerpla/gems-status"
  s.email    = "jmassaguerpla@suse.de"
  s.authors  = ["Jordi Massaguer Pla"]

  s.files    = %w( LICENSE )
  s.files    += Dir.glob("lib/**/*")
  s.files    += Dir.glob("bin/**/*")
  s.files    += Dir.glob("test/*")
  s.files    += %w( VERSION )

  s.executables = %w( gems-status )
  s.description = "gem-status gets the list of gems you use from Gemfile.lock file and runs some checks on those gems. Checks that can be run are:
  
      * Does it has a license? If it does not, it can be a problem for distributing your software with this gem.
      * Is it Gpl? If it is, it can be a problem if your software or other gems are not GPL compatible.
      * Is the same in Rubygems.org? This is for people who uses his own gem server. This checks the gems are the same.
      * Does it has security alerts? This will search into the commits and into security mailing lists for possible security messages.
                  "

  s.add_runtime_dependency 'xml-simple'
  s.add_runtime_dependency 'bundler'
  s.add_runtime_dependency 'gmail'
  s.add_runtime_dependency 'git'
  s.add_runtime_dependency 'mercurial-ruby'
  s.add_runtime_dependency 'json'

  s.add_development_dependency 'shoulda'
  s.add_development_dependency 'mocha'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'rspec'

  s.license = "MIT"

end



