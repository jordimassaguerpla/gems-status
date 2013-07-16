
require './test/test-helper.rb'
$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require 'test/unit'
require 'gems-status'

module GemsStatus
  class Utils
    def self.download_md5(name, version, gems_url)
      if name == "name"
        "12345"
      else
        "_"
      end
    end
    def self.download_license(name, version, gems_url)
      "license"
    end
    def self.download_date(name, version)
      Time.parse "2012/03/01"
    end
  end
  class IsRubygemsTest < Test::Unit::TestCase
    def test_check
      ch = IsRubygems.new([])
      gem = GemSimple.new("name", "version", "md5", "origin")
      def gem.md5
       return "12345"
      end
      assert ch.check?(gem)
      gem = GemSimple.new("name", "version", "md5", "origin")
      def gem.md5
       return "_"
      end
      assert !ch.check?(gem)
    end
  end
end
