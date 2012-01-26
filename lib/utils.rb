class Utils
  def Utils.check_parameters(classname, conf, parameters)
    if !conf['classname'] then
      $stderr.puts "ERROR: trying to initialize #{classname} when parameter classname does not exists"
      exit
    end
    if conf['classname'] != classname then
      $stderr.puts "ERROR: trying to initialize #{classname} when parameter classname is #{conf['classname']}"
      exit
    end
    parameters.each do |p|
      if !conf[p] then
        $stderr.puts "ERROR: parameter #{p} not found for #{classname}"
        exit
      end
    end
  end
end
