require "mercurial-ruby"

require "gems-status/checkers/scm_check_messages"

module GemsStatus

  class HgCheckMessages < ScmCheckMessages
    def initialize
      Mercurial.configure do |conf|
        conf.hg_binary_path = "/usr/bin/hg"
      end
    end

  private

    def message(commit)
      return commit.message
    end

    def messages(name, source_repo)
      if ! File.exists?(name)
        Mercurial::Repository.clone(source_repo, name, {})
      end
      repo = Mercurial::Repository.open(name)
      repo.pull
      return repo.commits
    end

    def commit_key(commit)
      return commit.hash_id
    end

    def date(commit)
      commit.date
    end

  end

end
