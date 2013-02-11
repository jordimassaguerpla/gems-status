$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require 'rubygems'
require 'test/unit'
require 'gems-status'

class TestNotRailsChecker < Test::Unit::TestCase
  def test_gem_with_no_deps
    gem = GemSimple.new("name", Gem::Version.new("1.2.3"), nil, nil, nil, nil)
    check = NotRailsChecker.new nil
    result = check.check?(gem)
    assert(!result)
  end
  def test_gem_with_no_deps_2
    gem = GemSimple.new("name", Gem::Version.new("1.2.3"), nil, nil, nil, [])
    check = NotRailsChecker.new nil
    result = check.check?(gem)
    assert(result)
  end
  def test_gem_with_rail_dep
    deps = [
      Gem::Dependency.new("rails", Gem::Requirement.new("> 0.0.0")),
      Gem::Dependency.new("foo", Gem::Requirement.new("> 0.0.0"))
    ]

    gem = GemSimple.new("name", Gem::Version.new("1.2.3"), nil, nil, nil, deps)
    check = NotRailsChecker.new nil
    result = check.check?(gem)
    assert(!result)
  end
  def test_gem_with_no_rail_dep
    deps = [
      Gem::Dependency.new("norails", Gem::Requirement.new("> 0.0.0")),
      Gem::Dependency.new("foo", Gem::Requirement.new("> 0.0.0"))
    ]

    gem = GemSimple.new("name", Gem::Version.new("1.2.3"), nil, nil, nil, deps)
    check = NotRailsChecker.new nil
    result = check.check?(gem)
    assert(result)
  end
  def test_gem_with_railties_dep
    deps = [
      Gem::Dependency.new("railties", Gem::Requirement.new("> 0.0.0")),
      Gem::Dependency.new("foo", Gem::Requirement.new("> 0.0.0"))
    ]

    gem = GemSimple.new("name", Gem::Version.new("1.2.3"), nil, nil, nil, deps)
    check = NotRailsChecker.new nil
    result = check.check?(gem)
    assert(!result)
  end
end
