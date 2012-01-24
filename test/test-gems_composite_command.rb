$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require 'test/unit'
require 'gems_composite_command'

class GemsCompositeCommandTest < GemsCompositeCommand
  attr_accessor :results
end

class TestGemsCompositeCommand < Test::Unit::TestCase
  def test_common_key_in_empty_results
    gemscompositecommand = GemsCompositeCommand.new
    result = gemscompositecommand.common_key?("this key does not exists")
    assert(!result)
  end
  def test_common_key_in_zero_coincidences_one_result
    gemscompositecommand = GemsCompositeCommandTest.new
    gemscompositecommand.results = [{"a key"=>"a value"}]
    result = gemscompositecommand.common_key?("this key does not exists")
    assert(!result)
  end
  def test_common_key_in_zero_coincidences_two_results
    gemscompositecommand = GemsCompositeCommandTest.new
    gemscompositecommand.results = [{"a key"=>"a value"},{"another key"=>"another value"}]
    result = gemscompositecommand.common_key?("this key does not exists")
    assert(!result)
  end
  def test_common_key_in_one_coincidence_one_results
    gemscompositecommand = GemsCompositeCommandTest.new
    gemscompositecommand.results = [{"a key"=>"a value"}]
    result = gemscompositecommand.common_key?("a key")
    assert(result)
  end
  def test_common_key_in_one_coincidence_two_results
    gemscompositecommand = GemsCompositeCommandTest.new
    gemscompositecommand.results = [{"a key"=>"a value"},{"another key"=>"another value"}]
    result = gemscompositecommand.common_key?("a key")
    assert(!result)
  end
  def test_common_key_in_two_coincidence_two_results
    gemscompositecommand = GemsCompositeCommandTest.new
    gemscompositecommand.results = [{"a key"=>"a value"},{"a key"=>"another value"}]
    result = gemscompositecommand.common_key?("a key")
    assert(result)
  end
end
