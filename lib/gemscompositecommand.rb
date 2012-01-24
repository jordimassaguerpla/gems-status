require "gemsimple"
require "gemscommand"

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

end
