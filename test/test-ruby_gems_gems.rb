require './test/test-helper.rb'
$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require 'test/unit'
require 'gems-status'

class RubyGemsGemsTest < RubyGemsGems
  def initialize
    @url = ""
    @specs  = ""
    @result = {}
  end

  def get_data
    return Marshal.dump([["test","0.8.6"]])
  end
end

class TestRubyGemsGems < Test::Unit::TestCase
 def test_get_rubygems_data
   rubygemsgems = RubyGemsGemsTest.new 
   rubygemsgems.execute
   rubygemsgems.result.each {|k,v| puts "k: #{k} v: #{v}"}
   result = rubygemsgems.result["test"][0].name
   assert_equal("test",result)
   result = rubygemsgems.result["test"][0].version
   assert_equal(Gem::Version.new("0.8.6"), result)
 end
end


