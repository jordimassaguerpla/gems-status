require "gem_simple"
require "gems_command"
require "not_native_gem_checker"
require "not_rails_checker"
require "exists_in_upstream"
require "view_results"

class GemsCompositeCommand < GemsCommand
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

  def add_checker(check_class)
    @checkers << check_class
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
    @checkers.each do |check_class|
      @results[@target].sort.each do |k, gem|
        @checker_results[gem.name].each { |g| check_class::description + gem.name unless check_class::check?(g) }
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
    if @results.length<2
      return false
    end
    return true
  end

  def print
    ViewResults::print_head
    ids = []
    @commands.each { |c| ids << c.ident }
    ViewResults::print_description(ids)
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
      ViewResults::print_results(k, @results, @target, checker_results, comments)
      @checker_results.delete(k) 
      @comments.delete(k)
    end
    ViewResults::print_tail(@checker_results, @comments)
  end
end
