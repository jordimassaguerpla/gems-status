require 'rubygems'
require 'gems-status/gems_status_metadata'
require 'gems-status/utils'

module GemsStatus

  class TextView

    def print_description(app)
      puts "gems-status report for #{app}"
      puts "---"
    end


    def print_results(gem_list, checker_results, comments)
      print_gem_list(gem_list)
      print_gem_comments(gem_list, comments)
      print_gem_checker_results(checker_results)
    end

    def print_head
    end

    def print_tail
      puts "---"
      date = Time.now.strftime('%a %b %d %H:%M:%S %Z %Y')
      puts "run by https://github.com/jordimassaguerpla/gems-status"
      puts "#{date} - version: #{GemsStatus::VERSION}"
    end

    private

    def print_gem_list(gem_list)
      puts "Gem list"
      puts ""
      gem_list.sort.each do |_, gem|
        puts "#{gem.name} #{gem.version} #{gem.license}"
      end
      puts ""
      puts "---"
    end

    def print_gem_comments(gem_list, comments)
      puts "Comments"
      puts ""
      gem_list.sort.each do |_, gem|
        if comments[gem.name]
          puts "#{gem.name}:"
          puts "#{comments[gem.name]}" 
          puts ""
        end
      end
      puts ""
      puts "---"
    end


    def print_gem_checker_results(checker_results)
      if checker_results.length == 0
        puts "Checker results: SUCCESS"
      else
        puts "Checker results: FAILURE"
      end
      puts ""
      checker_results.sort.each do |gem_name, checker_r|
        puts "#{gem_name}"
        checker_r.each do |checker|
          puts "#{checker.description}"
        end
        puts ""
      end
    end

  end
end
