class Utils
  attr_accessor :errors
  @@errors = {}

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

end
