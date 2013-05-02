require "gems-status/gem_simple"
require "gems-status/gems_command"
require "gems-status/text_view"

module GemsStatus

  class GemsCompositeCommand < GemsCommand
    attr_accessor :results, :checker_results, :command

    def initialize
      @command = []
      @checkers = []
      @checker_results = {}
      @comments = {}
      @results = []
    end

    def add_checker(check_object)
      @checkers << check_object
    end

    def execute
      return unless @command
      @command.execute
      @results << @command.result
      @checkers.each do |check_object|
        Utils::log_debug "checking #{check_object.class.name}"
        @results.each do |gems|
          gems.each do |name, gem|
            if !check_object.check?(gem)  
              @checker_results[name] = {} unless @checker_results[name]
              @checker_results[gem.name][check_object.class.name] = check_object
            end
          end
        end
      end
    end

    def add_comments(comments)
      @comments = comments
    end

    def are_there_results?
      return @results && !@results.empty?
    end

    def print
      return if !are_there_results?
      view = TextView.new
      view.print_head
      ids = @command.filename
      view.print_description(ids)
      view.print_results(@results, @checker_results, @comments)
      view.print_tail
    end
  end
end
