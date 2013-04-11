require "openssl"
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

module GemsStatus

  class Utils
    attr_accessor :errors
    @@errors = {}
    @@md5_sums = {}
    @@licenses = {}
    @@keys = {}
    @@gems = {}

    def Utils.errors
      return @@errors
    end

    def Utils.check_parameters(classname, conf, parameters)
      if !conf['classname'] then
        raise "trying to initialize #{classname} when parameter classname does not exists"
      end
      if conf['classname'] != classname then
        raise "trying to initialize #{classname} when parameter classname is #{conf['classname']}"
      end
      parameters.each do |p|
        if !conf[p] then
          raise "parameter #{p} not found for #{classname}"
        end
      end
    end

    def Utils.log_error(name, msg)
      @@errors[name] = "\n" unless @@errors[name]
      @@errors[name]  << msg << "\n"
      $stderr.puts "ERROR: #{msg}"
    end

    def Utils.log_debug(msg)
      $stderr.puts "DEBUG: #{msg}"
    end

    def Utils.download_md5(name, version, gems_url)
      key = "#{name}-#{version}-#{gems_url.gsub("/", "_").gsub(":", "_")}"
      return @@md5_sums[key] if @@md5_sums[key]
      begin
        gem_file_path = self.download_gem(name, version, gems_url)
      rescue Exception => e
        self.log_error(name, e.message)
        return nil
      end
      md5 = Digest::MD5.hexdigest(open(gem_file_path).read)
      @@md5_sums["#{name}-#{version}"] = md5
      return md5
    end

    def Utils.download_license(name, version, gems_url)
      key = "#{name}-#{version}-#{gems_url.gsub("/", "_").gsub(":", "_")}"
      return @@licenses[key] if @@licenses[key]
      begin
        gem_file_path = self.download_gem(name, version, gems_url)
      rescue Exception => e
        self.log_error(name, e.message)
        return nil
      end
      license = Gem::Format.from_file_by_path(gem_file_path).spec.license
      @@licenses[key] = license
      return license
    end

    private

    def Utils.download_gem(name, version, gems_url)
      gem_uri = URI.parse("#{gems_url}/#{name}-#{version}.gem")
      tmp_path = "tmp/utils/gems/#{gems_url.gsub("/", "_").gsub(":", "_")}/"
      gem_name = "#{name}-#{version}.gem"
      full_path = "#{tmp_path}/#{gem_name}"
      return full_path if File.exists? full_path
      uri_debug = gem_uri.clone
      uri_debug.password = "********" if uri_debug.password
      Utils::log_debug "download #{@name} from #{uri_debug}"
      FileUtils::mkdir_p(tmp_path) if ! File.exists?(tmp_path)
      if gem_uri.user && gem_uri.password
        source = open(gem_uri.scheme + "://" + gem_uri.host + "/" + gem_uri.path,
                     "rb",
                      :http_basic_authentication=>[gem_uri.user, gem_uri.password])
      else
        source = open(gem_uri)
      end
      open(full_path, "wb") do |file|
        file.write(source.read)
      end
      source.close
      return full_path
    end
  end
end
