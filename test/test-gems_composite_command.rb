$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require 'test/unit'
require 'gems-status'

class GemsCompositeCommandTest < GemsCompositeCommand
  attr_accessor :results
end

class TestGemsCompositeCommand < Test::Unit::TestCase
  def test_common_key_in_empty_results
    gemscompositecommand = GemsCompositeCommand.new('id')
    result = gemscompositecommand.common_key?("this key does not exists")
    assert(!result)
  end
  def test_common_key_in_zero_coincidences_one_result
    gemscompositecommand = GemsCompositeCommandTest.new('id')
    gemscompositecommand.results['id'] = {"a key"=>"a value"}
    result = gemscompositecommand.common_key?("this key does not exists")
    assert(!result)
  end
  def test_common_key_in_zero_coincidences_two_results
    gemscompositecommand = GemsCompositeCommandTest.new('id')
    gemscompositecommand.results['id'] = {"a key"=>"a value"}
    gemscompositecommand.results['id2'] = {"another key"=>"another value"}
    result = gemscompositecommand.common_key?("this key does not exists")
    assert(!result)
  end
  def test_common_key_in_one_coincidence_one_results
    gemscompositecommand = GemsCompositeCommandTest.new('id')
    gemscompositecommand.results['id']= {"a key"=>"a value"}
    result = gemscompositecommand.common_key?("a key")
    assert(!result)
  end
  def test_common_key_in_one_coincidence_two_results
    gemscompositecommand = GemsCompositeCommandTest.new('id')
    gemscompositecommand.results['id']= {"a key"=>"a value"}
    gemscompositecommand.results['id2']= {"another key"=>"another value"}
    result = gemscompositecommand.common_key?("a key")
    assert(!result)
  end
  def test_common_key_in_two_coincidence_two_results
    gemscompositecommand = GemsCompositeCommandTest.new('id')
    gemscompositecommand.results['id']= {"a key"=>"a value"}
    gemscompositecommand.results['id2']= {"a key"=>"another value"}
    result = gemscompositecommand.common_key?("a key")
    assert(result)
  end
end
