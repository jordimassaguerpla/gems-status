class Utils
  def Utils.check_parameters(classname, conf, parameters)
    if !conf['classname'] then
      raise "ERROR: trying to initialize #{classname} when parameter classname does not exists"
    end
    if conf['classname'] != classname then
      raise "ERROR: trying to initialize #{classname} when parameter classname is #{conf['classname']}"
    end
    parameters.each do |p|
      if !conf[p] then
        raise "ERROR: parameter #{p} not found for #{classname}"
      end
    end
  end
end
