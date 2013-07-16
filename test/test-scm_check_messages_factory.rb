require './test/test-helper.rb'
$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require 'test/unit'
require 'gems-status'

module GemsStatus
  class ScmCheckMessagesFactoryTest < Test::Unit::TestCase
    def test_instance
      assert_equal ScmCheckMessagesFactory.get_instance("bla"), nil
      assert_equal ScmCheckMessagesFactory.get_instance("git bla").class, GemsStatus::GitCheckMessages
      assert_equal ScmCheckMessagesFactory.get_instance("svn bla").class, GemsStatus::SvnCheckMessages
      assert_equal ScmCheckMessagesFactory.get_instance("bitbucket bla").class, GemsStatus::HgCheckMessages
    end
  end
end
