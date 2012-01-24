$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require 'test/unit'
require 'ruby_gems_gems'

class RubyGemsGemsTest < Test::Unit::TestCase
 def test_not_implemented
  assert(false);
 end
end


