$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require 'test/unit'
require 'lockfile_gems'
require 'rubygems/dependency'

class LockfileGemsTest < LockfileGems
  attr_accessor :result
  def initialize
    #TODO: this won't work in other development machines!
    @filenames = ["/home/jordi/work/suse/gems-status/test/Gemfile.lock.test"]
    @gems_url = ""
    @result = {}
  end
end

class TestLockfileGems < Test::Unit::TestCase
 def test_get_rubygems_names
   lockfilegems = LockfileGemsTest.new
   lockfilegems.execute
   assert(lockfilegems.result.length == 6)
   result = lockfilegems.result["test"][0].name
   assert_equal("test",result)
   result = lockfilegems.result["test"][0].version
   assert_equal(Gem::Version.new("0.8.6"), result)
   result = lockfilegems.result["test2"][0].name
   assert_equal("test2",result)
   result = lockfilegems.result["test2"][0].version
   assert_equal(Gem::Version.new("1.2.3"), result)
   result = lockfilegems.result["test3"][0].name
   assert_equal("test3",result)
   result = lockfilegems.result["test3"][0].version
   assert_equal(Gem::Version.new("1.2.3"), result)
   result = lockfilegems.result["test4"][0].name
   assert_equal("test4",result)
   result = lockfilegems.result["test4"][0].version
   assert_equal(Gem::Version.new("1.2.3"), result)
   result = lockfilegems.result["from_git"][0].version
   assert_equal(Gem::Version.new("1.0.3"), result)
   result = lockfilegems.result["dep_from_git"][0].version
   assert_equal(Gem::Version.new("1.0.0"), result)
 end

 def test_get_rubygems_dependencies
   lockfilegems = LockfileGemsTest.new
   lockfilegems.execute
   result = lockfilegems.result["test"][0].dependencies
   assert(result)
   result = lockfilegems.result["test"][0].dependencies.length
   assert_equal(3, result)
   result = lockfilegems.result["test"][0].dependencies
   assert_equal(
     Gem::Dependency.new("test2", Gem::Requirement.new(["= 1.2.3"])),
     result[0]) 
   assert_equal(
     Gem::Dependency.new("test3", Gem::Requirement.new(["= 1.2.3"])),
     result[1]) 
   assert_equal(
     Gem::Dependency.new("test4", Gem::Requirement.new(["= 1.2.3"])),
     result[2]) 
 end

 def test_from_git
   lockfilegems = LockfileGemsTest.new
   lockfilegems.execute
   result = lockfilegems.result["from_git"][0].gems_url
   assert(result.start_with?("git://"))
   assert(lockfilegems.result["from_git"][0].from_git?)
 end
end

