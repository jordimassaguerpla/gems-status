#!/usr/bin/ruby
#TODO: implement license checker: ninka??
#TODO: do we need other checkers?
#TODO: implement a nicer interface
#TODO: move this to bin directory
#TODO: implement tests (need refactoring on getting the data)
 
require "rubygems"
require "xmlsimple"
require "open-uri"
require "yaml"

require "gemsimple"
require "obsgems"
require "lockfilegems"
require "rubygemsgems"
require "gemscompositecommand"

conf = YAML::load(File::open("../conf/test.yaml"))
gems_composite_command = GemsCompositeCommand.new
conf.each do |c| 
  gems = eval(c["classname"]).new(c)
  gems_composite_command.add_command(gems)
end
gems_composite_command.execute
gems_composite_command.print


