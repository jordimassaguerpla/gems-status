class PrintGemVersions
  def initialize(conf)
  end

  def check?(gem)
    #ignore upstream gems
    return true if gem.origin == gem.gems_url 
    open("gemversions.txt", "a") do |f|
      f.puts "name:#{gem.name} \tversion:#{gem.version}\t license:#{gem.license}"
    end
    return true
  end

end
