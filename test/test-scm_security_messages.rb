require './test/test-helper.rb'
$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require 'test/unit'
require 'gems-status'

module GemsStatus
  class TestScmSecurityMessages < Test::Unit::TestCase
    def test_check_message
      ssm = ScmSecurityMessages.new
      assert !ssm.check_message?("bla bla")
      assert ssm.check_message?("bla XSS bla")
      assert ssm.check_message?("bla CSRF bla")
      assert ssm.check_message?("bla cross-site bla")
      assert ssm.check_message?("bla crosssite bla")
      assert ssm.check_message?("bla injection bla")
      assert ssm.check_message?("bla forgery bla")
      assert ssm.check_message?("bla traversal bla")
      assert ssm.check_message?("bla CVE bla")
      assert ssm.check_message?("bla unsafe bla")
      assert ssm.check_message?("bla vulnerab bla")
      assert ssm.check_message?("bla risk bla")
      assert ssm.check_message?("bla security bla")
      assert ssm.check_message?("bla Malicious bla")
      assert ssm.check_message?("bla DoS bla")
    end
  end
end
