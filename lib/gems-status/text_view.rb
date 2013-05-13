require 'rubygems'
require 'gems-status/gems_status_metadata'
require 'gems-status/utils'

module GemsStatus

  class TextView

    def print_description(app)
      puts "gems-status report for #{app}"
      puts "---"
    end

    def print_results(results, checker_results, comments)
      results.each do |result|
        result.each do |_, gem|
          puts "#{gem.name} #{gem.version} #{gem.license}"
          puts "#{comments[gem.name]}" if comments[gem.name]
          puts ""
        end
      end
      puts "---"
      if checker_results.length == 0
        puts "Checker results: SUCCESS"
      else
        puts "Checker results: FAILURE"
      end
      checker_results.each do |gem_name, checker_r|
      puts "#{gem_name}"
        checker_r.each do |_, checker|
          puts "#{checker.description}"
        end
        puts ""
      end
    end

    def print_head
    end

    def print_tail
      puts "---"
      date = Time.now.strftime('%a %b %d %H:%M:%S %Z %Y')
      puts "run by https://github.com/jordimassaguerpla/gems-status"
      puts "#{date} - version: #{GemsStatus::VERSION}"
    end

  end
end
