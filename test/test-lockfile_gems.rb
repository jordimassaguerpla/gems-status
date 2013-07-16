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
    end
  end

  class TestLockfileGems < Test::Unit::TestCase
   def test_get_rubygems_names
     lockfilegems = LockfileGemsTest.new
     gem_list = lockfilegems.gem_list
     assert(gem_list.length == 6)
     result = gem_list["test"].name
     assert_equal("test",result)
     result = gem_list["test"].version
     assert_equal(Gem::Version.new("0.8.6"), result)
     result = gem_list["test2"].name
     assert_equal("test2",result)
     result = gem_list["test2"].version
     assert_equal(Gem::Version.new("1.2.3"), result)
     result = gem_list["test3"].name
     assert_equal("test3",result)
     result = gem_list["test3"].version
     assert_equal(Gem::Version.new("1.2.3"), result)
     result = gem_list["test4"].name
     assert_equal("test4",result)
     result = gem_list["test4"].version
     assert_equal(Gem::Version.new("1.2.3"), result)
     result = gem_list["from_git"].version
     assert_equal(Gem::Version.new("1.0.3"), result)
     result = gem_list["dep_from_git"].version
     assert_equal(Gem::Version.new("1.0.0"), result)
   end
   def test_filename
     conf = {}
     conf["filename"] = "fn"
     conf["gems_url"] = "gu"
     conf["classname"] = "LockfileGems"
     lg = GemsStatus::LockfileGems.new(conf)
     assert_equal(lg.filename, "fn")
   end

  end

end
