require './test/test-helper.rb'
$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require 'test/unit'
require 'gems-status'

module GemsStatus

  class MockSource
    def gem_list
      {
        "gem 1 name" => "gem 1 object",
        "gem 2 name" => "gem 2 object"
      }
    end
  end
  class MockChecker
    def check?(gem)
      false
    end
  end

  class RunnerTest < Test::Unit::TestCase
    def test_a_run
      runner = Runner.new
      assert !runner.are_there_gems?
      runner.source = MockSource.new
      assert !runner.are_there_gems?
      runner.add_checker(MockChecker.new)
      runner.add_checker(MockChecker.new)
      runner.execute
      assert runner.are_there_gems?
      expected = { "gem 1 name" => "gem 1 object", "gem 2 name" => "gem 2 object" }
      assert_equal expected, runner.gem_list
      assert_equal Array, runner.checker_results["gem 1 name"].class
      assert_equal 2, runner.checker_results["gem 1 name"].length
      assert_equal MockChecker, runner.checker_results["gem 1 name"][0].class
      assert runner.checker_results["gem 1 name"][0] != runner.checker_results["gem 1 name"][1]
    end
  end
end
