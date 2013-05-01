require './test/test-helper.rb'
$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require 'test/unit'
require 'gems-status'
require 'rubygems/dependency'

module GemsStatus

  class LockfileGemsTest < LockfileGems
    attr_accessor :result
    def initialize
      dir=File.expand_path(File.dirname(__FILE__))
      puts "DEBUG: dir : #{dir} #{dir.class.name}"
      @filename = "#{dir}/Gemfile.lock.test"
      @gems_url = ""
      @result = {}
    end
  end

  class TestLockfileGems < Test::Unit::TestCase
   def test_get_rubygems_names
     lockfilegems = LockfileGemsTest.new
     lockfilegems.execute
     assert(lockfilegems.result.length == 6)
     result = lockfilegems.result["test"].name
     assert_equal("test",result)
     result = lockfilegems.result["test"].version
     assert_equal(Gem::Version.new("0.8.6"), result)
     result = lockfilegems.result["test2"].name
     assert_equal("test2",result)
     result = lockfilegems.result["test2"].version
     assert_equal(Gem::Version.new("1.2.3"), result)
     result = lockfilegems.result["test3"].name
     assert_equal("test3",result)
     result = lockfilegems.result["test3"].version
     assert_equal(Gem::Version.new("1.2.3"), result)
     result = lockfilegems.result["test4"].name
     assert_equal("test4",result)
     result = lockfilegems.result["test4"].version
     assert_equal(Gem::Version.new("1.2.3"), result)
     result = lockfilegems.result["from_git"].version
     assert_equal(Gem::Version.new("1.0.3"), result)
     result = lockfilegems.result["dep_from_git"].version
     assert_equal(Gem::Version.new("1.0.0"), result)
   end

  end

end
