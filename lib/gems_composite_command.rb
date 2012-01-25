require "gem_simple"
require "gems_command"

class GemsCompositeCommand < GemsCommand
  def initialize
    @commands = []
    @results = []
  end

  def add_command(command)
    @commands << command
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
      @results << command.result
    end
  end

  def common_key?(k)
    if !@results or @results.empty?
      return false
    end
    @results.each do |result|
      if !result[k] then
        return false
      end
    end
    return true
  end

  def print_commons
    @results[0].each do |k,v| 
      if common_key?(k) then 
        puts "=== #{k}"
        @results.each do |result|
          puts "#{result[k].origin}"
          puts " version : #{result[k].version}"
          puts " md5: #{result[k].md5}"
          puts "---------"
        end
      end
    end
  end

  def equal_gems?(k)
    #TODO: test this!!!!
    if !common_key?(k)
      return false
    end
    if !@results or @results.empty?
      return false
    end
    version = @results[0][k].version
    md5 = @results[0][k].md5
    @results.each do |result|
      if result[k].version != version
        return false
      end
      if !result[k].md5 then
        next
      end
      if result[k].md5 != md5
        return false
      end
      version = result[k].version
      md5 = result[k].md5
    end
    return true
  end

  def print_commons_diff
    @results[0].each do |k,v| 
      if common_key?(k) then 
        if equal_gems?(k) then
          $stderr.puts "DEBUG:  equal gems: #{k}"
          next
        end
        puts "=== #{k}"
        @results.each do |result|
          puts "#{result[k].origin}"
          puts " version : #{result[k].version}"
          puts " md5: #{result[k].md5}"
          puts "---------"
        end
      end
    end
  end

  def print
    if !@results
      return
    end
    if !@results[0]
      return
    end
    if !@results[1]
      return
    end
    print_commons
  end

  def print_diff
    if !@results
      return
    end
    if !@results[0]
      return
    end
    if !@results[1]
      return
    end
    print_commons_diff
  end

end
