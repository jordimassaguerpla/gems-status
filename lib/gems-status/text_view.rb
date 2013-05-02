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
          puts "#{gem.name}: #{gem.version} #{gem.license}"
          next unless checker_results[gem.name]
          checker_results[gem.name].each do |_, checker|
            puts "#{checker.description}"
          end
          puts "#{comments[gem.name]}" if comments[gem.name]
          puts ""
        end
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
