require './test/test-helper.rb'
$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require 'test/unit'
require 'gems-status'

module GemsStatus
  class GemTest
    attr_accessor :license
  end
  class HasALicenseTest < Test::Unit::TestCase
    def test_check
      gem = GemTest.new
      gem.license = "something"
      assert GemsStatus::HasALicense.new(nil).check?(gem)
    end
  end
end
