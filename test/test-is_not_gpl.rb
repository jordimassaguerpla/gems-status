require './test/test-helper.rb'
$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require 'test/unit'
require 'gems-status'

module GemsStatus
  class GemTest
    attr_accessor :license
  end
  class IsNotGplTest < Test::Unit::TestCase
    def test_check
      gem = GemTest.new
      gem.license = "something"
      assert GemsStatus::IsNotGpl.new(nil).check?(gem)
      gem.license = "GPL"
      assert !GemsStatus::IsNotGpl.new(nil).check?(gem)
      gem.license = "GPLv2"
      assert !GemsStatus::IsNotGpl.new(nil).check?(gem)
      gem.license = "GPLblabla "
      assert !GemsStatus::IsNotGpl.new(nil).check?(gem)
    end

    def test_when_there_is_no_license
      gem = GemTest.new
      assert GemsStatus::IsNotGpl.new(nil).check?(gem)
    end
  end
end
