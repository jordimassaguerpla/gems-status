$LOAD_PATH.unshift 'lib'

Gem::Specification.new do |s|
  s.name     = "gems-status"
  s.version  = "0.1.0"
  s.date     = Time.now.strftime('%F')
  s.summary  = "compares rubygems from different sources"
  s.homepage = "http://github.com/jordimassaguerpla/gems-status"
  s.email    = "jmassaguerpla@suse.de"
  s.authors  = ["Jordi Massaguer Pla"]

  s.files    = %w( LICENSE )
  s.files    += Dir.glob("lib/**/*")
  s.files    += Dir.glob("bin/**/*")
  s.files    += Dir.glob("test/*")

  s.executables = %w( gems-status )
  s.description = "gem-status compares rubygems information from different sources as for reporting which gems are outdated. Sources can be opensuse build service, rubygems.org or a gemfile.lock. Data compared is version and md5sum"

  s.add_runtime_dependency 'xml-simple'
  s.add_runtime_dependency 'bundler'
end



