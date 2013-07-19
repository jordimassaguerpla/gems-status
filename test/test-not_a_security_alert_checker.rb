require './test/test-helper.rb'
$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require 'test/unit'
require 'gems-status'

module GemsStatus
  class NotASecurityAlertChecker
    attr_reader :security_messages, :fixed
    attr_accessor :emails
    def initialize(conf)
      @security_messages = {}
      @fixed = {}
    end
    public :match_name, :key_for_emails, :look_in_emails, :gem_uri, :filter_security_messages_already_fixed
  end
  class MockGem
    def name
      "NAME"
    end
    def origin
      "ORG"
    end
    def date
      Date.new(2012, 12, 12)
    end
    def gems_url
      "http://rubygems.org/gems"
    end
    def version
      "1.2.3"
    end
  end
  class MockEmail
    def uid
      "UID"
    end
    def subject
      "subject"
    end
  end
  class NotASecurityAlertCheckerTest <Test::Unit::TestCase 
    def test_match_name
      ch = NotASecurityAlertChecker.new([])
      assert ch.match_name("rubygem mail", "mail")
      assert !ch.match_name("mail","mail")
      assert ch.match_name("ruby mail", "mail")
      assert ch.match_name("mail gem", "mail")
    end

    def test_key_for_emails
     ch = NotASecurityAlertChecker.new([])
     result = ch.key_for_emails( "LN", MockGem.new, MockEmail.new)
      assert_equal "email_LN_NAME_ORG_UID", result
    end

    def test_look_in_emails_for_rubyonrails_sec_mail
      ch  = NotASecurityAlertChecker.new([])
      ch.emails = {
        "rubyonrails-security@googlegroups.com" => [MockEmail.new]
      }
      gem = MockGem.new
      def gem.name
        "rails"
      end
      assert_equal Hash, ch.security_messages.class
      assert_equal 0, ch.security_messages.length
      ch.look_in_emails(gem)
      assert_equal Hash, ch.security_messages.class
      assert_equal 1, ch.security_messages.length
    end

    def test_look_in_emails_for_other_mail
      mail = MockEmail.new
      def mail.subject
        "gem rails"
      end
      ch  = NotASecurityAlertChecker.new([])
      ch.emails = {
        "other" => [mail]
      }
      gem = MockGem.new
      def gem.name
        "rails"
      end
      assert_equal Hash, ch.security_messages.class
      assert_equal 0, ch.security_messages.length
      ch.look_in_emails(gem)
      assert_equal Hash, ch.security_messages.class
      assert_equal 1, ch.security_messages.length
    end

    def test_gem_uri_with_project_uri
      ch = NotASecurityAlertChecker.new([])

      result = ch.gem_uri({"project_uri" => "github.com/a"})
      assert_equal "github.com/a", result
      result = ch.gem_uri({"project_uri" => "a"})
      assert_equal nil, result
    end

    def test_gem_uri_with_homepage_url
      ch = NotASecurityAlertChecker.new([])

      result = ch.gem_uri({"homepage_uri" => "github.com/a"})
      assert_equal "github.com/a", result
      result = ch.gem_uri({"homepage_uri" => "a"})
      assert_equal nil, result
    end

    def test_gem_uri_with_source_code_uri
      ch = NotASecurityAlertChecker.new([])

      result = ch.gem_uri({"source_code_uri" => "github.com/a"})
      assert_equal "github.com/a", result
      result = ch.gem_uri({"source_code_uri" => "a"})
      assert_equal nil, result
    end

    def test_filter_security_messages_already_fixed_with_equal_version
      ch = NotASecurityAlertChecker.new([])
      gem = MockGem.new
      ch.security_messages["key"] = gem
      ch.fixed["key"] = "1.1.1"
      version = Gem::Version.new("1.1.1")
      date = Date.new(2011, 12, 12)
      ch.filter_security_messages_already_fixed(version, date)
      assert_equal 0, ch.security_messages.length
    end

    def test_filter_security_messages_already_fixed_with_newer_version
      ch = NotASecurityAlertChecker.new([])
      gem = MockGem.new
      ch.security_messages["key"] = gem
      ch.fixed["key"] = "1.1.0"
      version = Gem::Version.new("1.1.1")
      date = Date.new(2011, 12, 12)
      ch.filter_security_messages_already_fixed(version, date)
      assert_equal 0, ch.security_messages.length
    end

    def test_filter_security_messages_already_fixed_with_older_version
      ch = NotASecurityAlertChecker.new([])
      gem = MockGem.new
      ch.security_messages["key"] = gem
      ch.fixed["key"] = "1.1.2"
      version = Gem::Version.new("1.1.1")
      date = Date.new(2011, 12, 12)
      ch.filter_security_messages_already_fixed(version, date)
      assert_equal 1, ch.security_messages.length
    end

    def test_filter_security_messages_already_fixed_with_newer_date
      ch = NotASecurityAlertChecker.new([])
      gem = MockGem.new
      ch.security_messages["key"] = gem
      ch.fixed["key"] = "1.1.2"
      version = Gem::Version.new("1.1.1")
      date = Date.new(2013, 12, 12)
      ch.filter_security_messages_already_fixed(version, date)
      assert_equal 0, ch.security_messages.length
    end

    def test_check
      ch = NotASecurityAlertChecker.new([])
      gem = MockGem.new
      def ch.look_in_scm(gem)
      end
      def ch.look_in_emails(gem)
      end
      def ch.filter_security_messages_already_fixed(version, date)
      end
      def ch.send_emails(gem)
      end
      assert ch.check?(gem)
      def ch.look_in_scm(gem)
        @security_messages[gem] = ""
      end
      assert !ch.check?(gem)
    end

  end
end
