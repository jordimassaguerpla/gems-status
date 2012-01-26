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

  def equal_gems?(k)
    if !@results or @results.empty?
      return false
    end
    if !common_key?(k)
      return false
    end
    version = @results[0][k].version
    md5 = @results[0][k].md5
    @results.each do |result|
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
    if !@results
      return false
    end
    if !@results[0]
      return false
    end
    if !@results[1]
      return false
    end
    return true
  end

  def print_html_diff
    if !are_there_results?
      return
    end
    puts "<table width='100%'>"
    @results[0].each do |k,v| 
      if !common_key?(k) then 
        next
      end
      if equal_gems?(k) then
        $stderr.puts "DEBUG:  equal gems: #{k}"
        next
      end
      puts "<tr><td><span style='font-weight:bold;'>#{k}</span></td></tr>"
      version = @results[0][k].version
      md5 = @results[0][k].md5
      @results.each do |result|
        puts "<tr>"
        puts "<td>"
        puts "#{result[k].origin}"
        puts "</td>"
        puts "<td>"
        v_color = "black"
        md5_color = "black"
        if version != result[k].version then
          v_color = "red"
        else
          if md5 != result[k].md5 then
            md5_color = "red"
          end
        end
        puts "<span style='color: #{v_color}'>"
        if !version then
          puts "error: look error log"
        end
        puts "#{result[k].version}"
        puts "</span>"
        puts "</td>"
        puts "<td>"
        puts "<span style='color: #{md5_color}'>"
        if result[k].md5.empty? then
          puts "error: look error log"
        end
        puts "#{result[k].md5}"
        puts "</span>"
        puts "</td>"
        puts "</tr>"
        version = result[k].version
        md5 = result[k].md5
      end
    end
    puts "</table>"
  end

end
