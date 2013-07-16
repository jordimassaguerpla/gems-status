require "gems-status/gem_simple"
require "gems-status/text_view"

module GemsStatus

  class Runner
    attr_accessor :gem_list, :checker_results, :source

    def initialize
      @source = nil
      @checkers = []
      @checker_results = {}
      @comments = {}
      @gem_list = nil
    end

    def add_checker(check_object)
      @checkers << check_object
    end

    def execute
      return unless @source
      @gem_list = @source.gem_list
      @checkers.each do |check_object|
        Utils::log_debug "checking #{check_object.class.name}"
        @gem_list.each do |name, gem|
          if !check_object.check?(gem)
            @checker_results[name] = [] unless @checker_results[name]
            @checker_results[gem.name] << check_object.clone
          end
        end
      end
    end

    def add_comments(comments)
      @comments = comments
    end

    def are_there_gems?
      return @gem_list && !@gem_list.empty?
    end

    def print
      return if !are_there_gems?
      view = TextView.new
      view.print_head
      ids = @source.filename
      view.print_description(ids)
      view.print_results(@gem_list, @checker_results, @comments)
      view.print_tail
    end
  end
end
