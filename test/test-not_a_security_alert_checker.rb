require './test/test-helper.rb'
$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require 'test/unit'
require 'gems-status'

module GemsStatus
  class NotASecurityAlertChecker
    def initialize(conf)
    end
    public :match_name
  end
  class NotASecurityAlertCheckerTest <Test::Unit::TestCase 
    def test_match_name
      ch = NotASecurityAlertChecker.new([])
      assert ch.match_name("rubygem mail", "mail")
      assert !ch.match_name("mail","mail")
      assert ch.match_name("ruby mail", "mail")
      assert ch.match_name("mail gem", "mail")
    end
  end
end
