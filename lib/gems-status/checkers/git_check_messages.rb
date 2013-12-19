require "git"

require "gems-status/checkers/scm_check_messages"

module GemsStatus

  class GitCheckMessages < ScmCheckMessages
    # This value is the maximum log entries that git.log accepts.
    # It is a magic number found through testing.
    MAX_NUM_MESSAGES = 8688

  private

    def message(commit)
      return commit.message
    end

    def messages(name, source_repo)
      begin
        puts "DEBUG: about to open #{source_repo}"
        g = Git.open(name)
        puts "DEBUG: opened #{source_repo}"
      rescue
        puts "DEBUG: about to clone #{source_repo}"
        g = Git.clone(source_repo, name)
        puts "DEBUG: cloned #{source_repo}"
      end
      puts "DEBUG: about to pull from #{source_repo}"
      g.lib.send(:command, 'pull')
      puts "DEBUG: pulling finished"
      return g.log MAX_NUM_MESSAGES
    end

    def commit_key(commit)
      return commit.sha
    end

    def date(commit)
      commit.date
    end

  end
end
