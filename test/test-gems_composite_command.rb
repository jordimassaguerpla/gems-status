require './test/test-helper.rb'
$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require 'test/unit'
require 'gems-status'

module GemsStatus

  class GemsCompositeCommandTest < GemsCompositeCommand
    attr_accessor :results
  end

  class TestGemsCompositeCommand < Test::Unit::TestCase
  end
end
