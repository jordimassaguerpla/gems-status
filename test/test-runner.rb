require './test/test-helper.rb'
$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require 'test/unit'
require 'gems-status'

module GemsStatus

  class GemsRunnerTest < GemsStatus::Runner
    attr_accessor :results
  end

  class RunnerTest < Test::Unit::TestCase
  end
end
