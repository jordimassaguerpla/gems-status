#!/usr/bin/ruby


 
require "rubygems"
require "xmlsimple"
require "open-uri"
require "yaml"

require "gem_simple"
require "obs_gems"
require "lockfile_gems"
require "ruby_gems_gems"
require "gems_composite_command"

class GemStatus
  def initialize(conf_file)
    @conf_file = conf_file
    begin
      @conf = YAML::load(File::open(conf_file))
    rescue
      Utils::log_error("?", "There was a problem opening #{conf_file}")
    end
  end

  def execute
    gems_composite_command = GemsCompositeCommand.new(@conf["target"])
    @conf["sources"].each do |c| 
      gems = eval(c["classname"]).new(c)
      gems_composite_command.add_command(gems)
    end
    if @conf["checkers"]
      @conf["checkers"].each do |c|
       gems_composite_command.add_checker(eval(c["classname"]))
      end
    end
    if @conf["comments"]
      gems_composite_command.add_comments(@conf["comments"])
    end
    gems_composite_command.execute
    gems_composite_command.print
  end
end

