$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require 'test/unit'
require 'lockfile_gems'

class LockfileGemsTest < LockfileGems
  attr_accessor :result
  def initialize
    @dirname = "."
    @filename = "Gemfile.lock.test"
    @gems_url = ""
    @result = {}
  end
end

class TestLockfileGems < Test::Unit::TestCase
 def test_get_rubygems_data
   lockfilegems = LockfileGemsTest.new
   lockfilegems.execute
   assert(lockfilegems.result.length == 2)
   result = lockfilegems.result["test"].name
   assert_equal("test",result)
   result = lockfilegems.result["test"].version
   assert_equal(Gem::Version.new("0.8.6"), result)
   result = lockfilegems.result["test2"].name
   assert_equal("test2",result)
   result = lockfilegems.result["test2"].version
   assert_equal(Gem::Version.new("1.2.3"), result)
 end
end

