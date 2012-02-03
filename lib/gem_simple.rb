class GemSimple
  attr_reader :name, :version, :md5, :origin, :gems_url
  def initialize(name, version, md5, origin, gems_url=nil )
    @name = name
    @version = version
    @md5 = md5
    @origin = origin
    @gems_url = gems_url
  end
end

