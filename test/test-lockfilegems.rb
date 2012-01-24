$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require 'test/unit'
require 'lockfilegems'

class LockFileGemsTest < Test::Unit::TestCase
 def test_not_implemented
  assert(false);
 end
end

