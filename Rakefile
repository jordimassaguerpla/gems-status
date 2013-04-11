task :default => :test
require 'rake/testtask'

Rake::TestTask.new(:test) do |test|
  test.libs  << 'test'
  test.verbose = true
end

desc "release next version"
task :release do
  f = open("VERSION", "r")
  version = f.read().strip
  f.close
  version_split = version.scan /([0-9]+)\.([0-9]+)\.([0-9]+)/
  version_split.flatten!
  next_minor = eval(version_split[1]) + 1
  next_version = "#{version_split[0]}.#{next_minor}.#{version_split[2]}"
  puts "update VERSION file with #{next_version}"
  f = open("VERSION", "w")
  f.write(next_version)
  f.close
  puts "build gems-status-#{next_version}.gem"
  `gem build gems-status.gemspec`
  puts "update Gemfile.lock"
  `bundle check`
  puts "commit VERSION and Gemfile.lock"
  `git add VERSION Gemfile.lock`
  `git commit -m "bump version #{next_version}"`
  puts "tag git with #{next_version}"
  `git tag #{next_version}`
  puts "git push to origin"
  `git push origin HEAD --tags`
  puts "push gems-status-#{next_version}.gem to rubygems"
  `gem push gems-status-#{next_version}.gem`
  puts "Done!"
end



