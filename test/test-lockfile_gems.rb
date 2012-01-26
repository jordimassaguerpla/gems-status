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
   result = lockfilegems.result["test"].name
   assert_equal("test",result)
   result = lockfilegems.result["test"].version
   assert_equal(Gem::Version.new("0.8.6"), result)
 end
end

