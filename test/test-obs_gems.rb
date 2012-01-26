$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require 'test/unit'
require 'obs_gems'

class OBSGemsTest < OBSGems
  attr_accessor :result
  def get_data(url)
    if !url then
        return '<directory count="1"> 
                <entry name="rubygem-test"/>
                </directory>'
    end
    return '<directory name="rubygem-test" rev="3" vrev="3" srcmd5="85dff037c5d450f68e3724af3624c6b4">
             <entry name="rubygem-test.changes" md5="410f50267b43b7dba33b54cb3f588ecb" size="284" mtime="1276279120" />
             <entry name="rubygem-test.spec" md5="6a519f6a782a6f3cb151feef1ab69aaa" size="1827" mtime="1276279120" />
             <entry name="test-0.8.6.gem" md5="123" size="12288" mtime="1262870828" />
           </directory>
          '
  end
  def initialize
    @result = {}
    @username = ""
    @password = ""
    @obs_url = ""
    @repo = ""
  end
end

class TestObsGems < Test::Unit::TestCase
 def test_get_rubygem_data
   obsgems = OBSGemsTest.new
   obsgems.execute
   result = obsgems.result["test"].name
   assert_equal("test", result)
   result = obsgems.result["test"].version
   assert_equal(Gem::Version.new("0.8.6"), result)
   result = obsgems.result["test"].md5
   assert_equal("123", result)
 end
end


