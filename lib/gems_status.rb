#!/usr/bin/ruby
#TODO: implement license checker: ninka??
#TODO: do we need other checkers?
#TODO: implement a nicer interface
#TODO: is_native? == has extensions
#require 'rubygems/format'
#Gem::Format.from_file_by_path("curb-0.8.0.gem").spec.extensions
#
#open "curb-0.8.0.gem", Gem.binary_mode do |io|
#result = Gem::Format.from_io io
#end
#result.spec.extensions
#
#and for rails:
#result.spec.requirements
#result.spec.dependencies

 
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
    gems_composite_command.execute
    puts "<html><head></head><body>"
    gems_composite_command.print_html_diff
    puts "</html"
  end

end

