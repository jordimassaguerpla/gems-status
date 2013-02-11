require './test/test-helper.rb'
$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require 'test/unit'
require 'rubygems'
require 'gems-status'

class TestUtils < Test::Unit::TestCase
  def test_check_parameters_no_classname
    begin
      Utils::check_parameters("classname", {}, [])
      assert(false)
    rescue RuntimeError
      assert(true)
    end
  end
  def test_check_parameters_different_class_name
    begin
      Utils::check_parameters("classname", { "classname" => "wrong_classname" },
                              [])
      assert(false)
    rescue RuntimeError
      assert(true)
    end
  end
  def test_check_parameters_equal_class_name
    begin
      Utils::check_parameters("classname", { "classname" => "classname" }, 
                              [])
      assert(true)
    rescue RuntimeError
      assert(false)
    end
  end
  def test_check_parameters_wrong_parameters
    begin
      Utils::check_parameters("classname", { "classname" => "classname" }, 
                              [ "parameter" ])
      assert(false)
    rescue RuntimeError
      assert(true)
    end
  end
  def test_check_parameters_rigth_parameters
    begin
      Utils::check_parameters("classname", { "classname" => "classname", 
                              "parameter" => "value" }, [ "parameter" ])
      assert(true)
    rescue RuntimeError
      assert(false)
    end
  end
end
