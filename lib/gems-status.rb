#!/usr/bin/ruby
 
require "rubygems"
require "xmlsimple"
require "open-uri"
require "yaml"

require "gems-status/gem_simple"
require "gems-status/sources.rb"
require "gems-status/gems_composite_command"
require "gems-status/checkers"

module GemsStatus

  class GemStatus
    def initialize(conf)
      @conf = conf
    end

    def execute
      gems_composite_command = GemsCompositeCommand.new(@conf["target"])
      @conf["sources"].each do |c| 
        gems = eval(c["classname"]).new(c)
        gems_composite_command.add_command(gems)
      end
      if @conf["checkers"]
        @conf["checkers"].each do |c|
          checker = eval(c["classname"]).new(c)
         gems_composite_command.add_checker(checker)
        end
      end
      if @conf["comments"]
        gems_composite_command.add_comments(@conf["comments"])
      end
      gems_composite_command.execute
      gems_composite_command.print
    end
  end
end

