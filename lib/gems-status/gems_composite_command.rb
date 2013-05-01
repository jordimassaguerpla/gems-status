require "gems-status/gem_simple"
require "gems-status/gems_command"
require "gems-status/html_view"

module GemsStatus

  class GemsCompositeCommand < GemsCommand
    attr_accessor :results, :checker_results

    def initialize(target)
      @commands = []
      @checkers = []
      @checker_results = {}
      @comments = {}
      @results = {}
      @target = target
    end

    def add_command(command)
      @commands << command
    end

    def add_checker(check_object)
      @checkers << check_object
    end

    def execute
      threads = []
      if !@commands then
        return
      end
      @commands.each do |command|
        threads << Thread.new { command.execute }
      end
      threads.each { |aThread| aThread.join }
      @commands.each do |command|
        @results[command.ident] = command.result
      end
      @checkers.each do |check_object|
        Utils::log_debug "checking #{check_object.class.name}"
        @results[@target].sort.each do |k, gems|
          gems.each do |gem|
            if !check_object.check?(gem)  
             @checker_results[k] = {} unless @checker_results[k]
             @checker_results[gem.name][check_object.class.name] = "
             <br/>#{gem.name} #{gem.version} #{gem.origin}: <br/>
             #{check_object.description} " 
            end
          end
        end
      end
    end

    def common_key?(k)
      if !are_there_results?
        return false
      end
      @results.each do |key, result|
        if !result[k] then
          return false
        end
      end
      return true
    end

    def add_comments(comments)
      @comments = comments
    end

    def are_there_results?
      if !@results or @results.empty?
        return false
      end
      if !@results.has_key?(@target)
        return false
      end
      return true
    end

    def print
      html_view = HTMLView.new
      html_view.print_head
      ids = []
      @commands.each { |c| ids << c.ident }
      html_view.print_description(ids)
      if !are_there_results?
        return
      end
      @results[@target].sort.each do |k,v| 
        if !common_key?(k) then 
          Utils::log_error(k, "#{k} in #{@target} but not found in all the sources!")
        end
        if @checker_results[k]
          checker_results = @checker_results[k]
        else
          checker_results = nil
        end
        if @comments[k]
          comments = @comments[k]
        else
          comments = nil
        end
        html_view.print_results(k, @results, @target, checker_results, comments)
        @comments.delete(k)
      end
      html_view.print_tail(@checker_results, @comments)
    end
  end
end
