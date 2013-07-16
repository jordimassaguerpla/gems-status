require './test/test-helper.rb'
$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require 'test/unit'
require 'gems-status'

module GemsStatus
  class SecurityAlertTest < Test::Unit::TestCase
    def test_new
      sa = GemsStatus::SecurityAlert.new("desc", "date")
      assert sa.desc = "desc"
      assert sa.date = "date"
    end

  end
end
