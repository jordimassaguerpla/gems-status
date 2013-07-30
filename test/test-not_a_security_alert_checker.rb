require './test/test-helper.rb'
$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require 'test/unit'
require 'gems-status'

module GemsStatus
  class MockSecurityAlert
    def desc
      "description"
    end
  end
  class NotASecurityAlertChecker
    attr_reader :security_messages, :fixed
    attr_accessor :emails
    def initialize(conf)
      @security_messages = {}
      @fixed = {}
    end
    #make this methods public in order to test them
    public :match_name, :key_for_emails, :look_in_emails, :gem_uri, :filter_security_messages_already_fixed, :message
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
      assert ch.match_name("mail rubygem", "mail")
      assert !ch.match_name("mail","mail")
      assert ch.match_name("gem mail", "mail")
      assert ch.match_name("gem mail something", "mail")
      assert ch.match_name("ruby something mail", "mail")
      assert ch.match_name("ruby something mail something", "mail")
      assert ch.match_name("something ruby something mail", "mail")
      assert ch.match_name("mail gem", "mail")
      assert ch.match_name("mail something gem", "mail")
      assert ch.match_name("mail gem something", "mail")
      assert ch.match_name("mail ruby", "mail")
      assert ch.match_name("something mail ruby", "mail")
      assert ch.match_name("something mail ruby something", "mail")
      assert ch.match_name("ruby something mail", "mail")
      assert !ch.match_name("ruby somethingmail", "mail")
      assert !ch.match_name("somethingmail ruby", "mail")
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

    def test_look_in_emails_for_gem_name
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

    def test_look_in_emails_for_invalid_gem_name
      mail = MockEmail.new
      def mail.subject
        "rails issue"
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
      assert_equal 0, ch.security_messages.length
    end

    def test_look_in_emails_for_other_gem
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
        "other"
      end
      assert_equal Hash, ch.security_messages.class
      assert_equal 0, ch.security_messages.length
      ch.look_in_emails(gem)
      assert_equal Hash, ch.security_messages.class
      assert_equal 0, ch.security_messages.length
    end

    def test_look_in_emails_for_ruby_and_gem_name
      mail = MockEmail.new
      def mail.subject
        "ruby blablabla rails"
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

    def test_look_in_emails_and_ignore_if_re_in_subject
      mail = MockEmail.new
      def mail.subject
        "Re: ruby blablabla rails"
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
      assert_equal 0, ch.security_messages.length
    end

    def test_look_in_emails_for_gem_name_in_a_word
      mail = MockEmail.new
      def mail.subject
        "gem something_rails"
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
      assert_equal 0, ch.security_messages.length
    end

    def test_look_in_emails_for_gem_name_in_a_word_2
      mail = MockEmail.new
      def mail.subject
        "gem rails_something"
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
      assert_equal 0, ch.security_messages.length
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

    def test_message
      ch = NotASecurityAlertChecker.new([])
      gem = MockGem.new
      result = ch.message(gem)
      assert result.split("\n")[0].include?(gem.name)
      assert result.split("\n")[0].include?(gem.version)
      assert result.split("\n")[0].include?(gem.origin)
    end

    def test_description
      ch = NotASecurityAlertChecker.new([])
      gem = MockGem.new
      def ch.look_in_scm(gem)
        @security_messages[gem] = MockSecurityAlert.new
      end
      def ch.look_in_emails(gem)
      end
      def ch.filter_security_messages_already_fixed(version, date)
      end
      def ch.send_emails(gem)
      end
      result = ch.description
      assert result == nil
      result = ch.check?(gem)
      result = ch.description
      assert result.split("\n")[0].include?(gem.name)
      assert result.split("\n")[0].include?(gem.version)
      assert result.split("\n")[0].include?(gem.origin)

    end

  end
end
