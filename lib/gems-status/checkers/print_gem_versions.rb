class PrintGemVersions
  def initialize(conf)
    Utils::check_parameters('PrintGemVersions', conf, ["licenses"])
    begin
      @licenses = YAML::load(File::open(conf["licenses"]))
    rescue
      Utils::log_error("?", "There was a problem opening #{conf["licenses"]}")
      @licenses = []
    end
  end

  def check?(gem)
    #ignore upstream gems
    return true if gem.origin == gem.gems_url 
    open("gemversions.txt", "a") do |f|
      if ! (license = gem.license)
        license = get_license_string( gem.name, gem.version.to_s)
      end
      f.puts "#{gem.name} #{gem.version} #{license}"
    end
    return true
  end

  private

  def get_license_string(name, version)
    return "" if ! @licenses[name]
    return "#{@licenses[name][version]}*" if @licenses[name][version]
    return "#{@licenses[name].sort.last.join("->")}**"
  end

end
