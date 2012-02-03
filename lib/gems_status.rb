#!/usr/bin/ruby
#TODO: implement a nicer interface
#


 
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
      $stderr.puts "ERROR: There was a problem opening #{conf_file}"
    end
  end

  def execute
    gems_composite_command = GemsCompositeCommand.new(@conf["target"])
    @conf["sources"].each do |c| 
      gems = eval(c["classname"]).new(c)
      gems_composite_command.add_command(gems)
    end
    @conf["checkers"].each do |c|
      gems_composite_command.add_checker(eval(c["classname"]))
    end
    gems_composite_command.execute
    puts "<html><head></head><body>"
    gems_composite_command.print_html_diff
    gems_composite_command.print_html_check
    puts "</body></html>"
  end

end

