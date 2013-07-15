#!/usr/bin/ruby
 
require "rubygems"
require "xmlsimple"
require "open-uri"
require "yaml"

require "gems-status/gem_simple"
require "gems-status/sources.rb"
require "gems-status/runner"
require "gems-status/checkers"

module GemsStatus

  class GemStatus
    def initialize(conf)
      @conf = conf
      Utils::known_licenses = @conf["licenses"]
      @runner = nil
      @runner = GemsStatus::Runner.new
      c = @conf["source"]
      gems = eval(c["classname"]).new(c)
      @runner.command = gems
      if @conf["checkers"]
        @conf["checkers"].each do |c|
          checker = eval(c["classname"]).new(c)
         @runner.add_checker(checker)
        end
      end
      if @conf["comments"]
        @runner.add_comments(@conf["comments"])
      end
    end

    def execute
      @runner.execute
    end

    def results
      {:results => @runner.results, :checker_results => @runner.checker_results}
    end

    def print
      @runner.print
    end
  end
end

