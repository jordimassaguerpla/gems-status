require "openssl"
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

class Utils
  attr_accessor :errors
  @@errors = {}
  @@md5_sums = {}

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

  def Utils.download_md5(gem_uri)
    return @@md5_sums[gem_uri] if @@md5_sums[gem_uri]
    if gem_uri.user && gem_uri.password
      source = open(gem_uri.scheme + "://" + gem_uri.host + "/" + gem_uri.path, 
                    :http_basic_authentication=>[gem_uri.user, gem_uri.password])
    else
      source = open(gem_uri)
    end
    md5 = Digest::MD5.hexdigest(source.read)
    @@md5_sums[gem_uri] = md5
    return md5
  end

end
