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
  def test_equals_when_no_common_keys
    gemscompositecommand = GemsCompositeCommandTest.new
    gem1 = GemSimple.new("foo_name","foo_version","md5","origin1")
    gem2 = GemSimple.new("foo_name","foo_version","md5","origin2")
    gem3 = GemSimple.new("bar_name","bar_version","md5","origin3")
    gemscompositecommand.results = [{"foo"=>gem1},{"foo"=>gem2},{"bar"=>gem3}]
    result = gemscompositecommand.equal_gems?("foo")
    assert(!result)
  end
  def test_equals_when_version_not_equals
    gemscompositecommand = GemsCompositeCommandTest.new
    gem1 = GemSimple.new("foo_name","foo_version","md5","origin1")
    gem2 = GemSimple.new("foo_name","foo_version","md5","origin2")
    gem3 = GemSimple.new("foo_name","bar_version","md5","origin3")
    gemscompositecommand.results = [{"foo"=>gem1},{"foo"=>gem2},{"foo"=>gem3}]
    result = gemscompositecommand.equal_gems?("foo")
    assert(!result)
  end
  def test_equals_when_md5_not_equals
    gemscompositecommand = GemsCompositeCommandTest.new
    gem1 = GemSimple.new("foo_name","foo_version","md5","origin1")
    gem2 = GemSimple.new("foo_name","foo_version","md5","origin2")
    gem3 = GemSimple.new("foo_name","foo_version","md5_2","origin3")
    gemscompositecommand.results = [{"foo"=>gem1},{"foo"=>gem2},{"foo"=>gem3}]
    result = gemscompositecommand.equal_gems?("foo")
    assert(!result)
  end
  def test_equals_when_equals
    gemscompositecommand = GemsCompositeCommandTest.new
    gem1 = GemSimple.new("foo_name","foo_version","md5","origin1")
    gem2 = GemSimple.new("foo_name","foo_version","md5","origin2")
    gem3 = GemSimple.new("foo_name","foo_version","md5","origin3")
    gemscompositecommand.results = [{"foo"=>gem1},{"foo"=>gem2},{"foo"=>gem3}]
    result = gemscompositecommand.equal_gems?("foo")
    assert(result)
  end
  def test_equals_when_no_results
    gemscompositecommand = GemsCompositeCommandTest.new
    result = gemscompositecommand.equal_gems?("foo")
    assert(!result)
  end
end
