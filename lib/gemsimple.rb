class GemSimple
  attr_reader :name, :version, :md5, :origin
  def initialize(name, version, md5, origin)
    @name = name
    @version = version
    @md5 = md5
    @origin = origin
  end
end

