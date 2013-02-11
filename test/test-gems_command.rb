require './test/test-helper.rb'
$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require 'test/unit'
require 'gems-status'

class TestGemsCommand < Test::Unit::TestCase
  def test_gem_name_wrong_name
    gem_name = 'wrong_name'
    result = GemsCommand.new.gem_name(gem_name)
    expected = gem_name
    assert_equal(result, expected)
  end

  def test_gem_name_without_version
    gem_name = 'name.gem'
    result = GemsCommand.new.gem_name(gem_name)
    expected = 'name'
    assert_equal(result, expected)
  end

  def test_gem_name_simple
    gem_name = 'name-1.0.0.gem'
    result = GemsCommand.new.gem_name(gem_name)
    expected = 'name'
    assert_equal(result, expected)
  end

  def test_gem_name_with_dashes
    gem_name = 'name-1-1.0.0.gem'
    result = GemsCommand.new.gem_name(gem_name)
    expected = 'name-1'
    assert_equal(result, expected)
  end

  def test_gem_version_no_version
    gem_name = 'name.gem'
    result = GemsCommand.new.gem_version(gem_name)
    expected = '-1'
    assert_equal(result, expected)
  end

  def test_gem_version_wrong_name
    gem_name = 'name-1.0'
    result = GemsCommand.new.gem_version(gem_name)
    expected = '-1'
    assert_equal(result, expected)
  end

  def test_gem_version_simple_version
    gem_name = 'name-1.0.0.gem'
    result = GemsCommand.new.gem_version(gem_name)
    expected = '1.0.0'
    assert_equal(result, expected)
  end

  def test_gem_version_with_dashes
    gem_name = 'name-a-1.0.0.gem'
    result = GemsCommand.new.gem_version(gem_name)
    expected = '1.0.0'
    assert_equal(result, expected)
  end

end

