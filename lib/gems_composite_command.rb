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

  def equal_gems?(k)
    if !are_there_results?
      return false
    end
    if !common_key?(k)
      return false
    end
    version = @results[@target][k].version
    md5 = @results[@target][k].md5
    @results.each do |key, result|
      if result[k].version != version
        return false
      end
      if result[k].md5 != md5
        return false
      end
      version = result[k].version
      md5 = result[k].md5
    end
    return true
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
    @results[@target].each do |k,v| 
      if !common_key?(k) then 
        $stderr.puts "ERROR: #{k} in #{@target} but not found in all the sources!"
        next
      end
      if equal_gems?(k) then
        next
      end
      ViewResults::print_diff(k, @results, @target)
    end
    @checkers.each do |check_class|
      @results[@target].each do |k, gem|
        ViewResults::print_check(check_class::description, gem.name) unless check_class::check?(gem)
      end
    end
    ViewResults::print_tail
  end
end
