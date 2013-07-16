require './test/test-helper.rb'
$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require 'test/unit'
require 'gems-status'

module GemsStatus
  class ScmCheckMessages
    def commit_key(commit)
      commit[0..3]
    end

    def message(commit)
      commit
    end

    def messages(name, source_repo)
      ["#{name} - #{source_repo} - message"]
    end

    def date(commit)
      "2012-03-12"
    end

  end
  class MessageChecker
    def check_message?(commit)
      commit.include?("security")
    end
  end

  class ScmCheckMessagesTest < Test::Unit::TestCase
    def test_check_messages
      scm = ScmCheckMessages.new
      cm = scm.check_messages("name security", "source_repo", MessageChecker.new, "origin")
      assert_equal 1, cm.length
      cm = scm.check_messages("name", "source_repo", MessageChecker.new, "origin")
      assert_equal 0, cm.length
    end
  end
end
