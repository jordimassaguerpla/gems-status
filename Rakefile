task :default => :test
require 'rake/testtask'

Rake::TestTask.new(:test) do |test|
  test.libs  << 'test'
  test.verbose = true
end

require 'rcov/rcovtask'
Rcov::RcovTask.new do |t|
  t.test_files = FileList['test/test*.rb']
  t.verbose = true
  t.rcov_opts << "--exclude .rvm"
end


