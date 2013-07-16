require './test/test-helper.rb'
$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require 'test/unit'
require 'gems-status'

module GemsStatus
  class Utils
    def self.download_md5(name, version, gems_url)
      "12345"
    end
    def self.download_license(name, version, gems_url)
      "license"
    end
    def self.download_date(name, version)
      Time.parse "2012/03/01"
    end
  end
  class GemSimpleTest < Test::Unit::TestCase
    def test_from_git
      gs = GemSimple.new("name", "version", "md5", "origin")
      assert !gs.from_git?
      gs = GemSimple.new("name", "version", "md5", "origin", "git://blalba")
      assert gs.from_git?
    end

    def test_license
      gs = GemSimple.new("name", "version", "md5", "origin")
      assert_equal gs.license, "license"
      gs = GemSimple.new("name", "version", "md5", "origin", "git://blalba")
      assert_equal gs.license, nil
    end

    def test_md5
      gs = GemSimple.new("name", "version", "md5", "origin")
      assert_equal gs.md5, "12345"
      gs = GemSimple.new("name", "version", "md5", "origin", "git://blalba")
      assert_equal gs.md5, nil
    end

    def test_date
      gs = GemSimple.new("name", "version", "md5", "origin")
      assert_equal gs.date, Time.parse("2012/03/01")
      gs = GemSimple.new("name", "version", "md5", "origin", "git://blalba")
      assert_equal gs.date, Time.parse("2012/03/01")
    end

  end
end
