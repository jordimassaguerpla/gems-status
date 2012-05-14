require "mercurial-ruby"

require "gems-status/scm_check_messages"

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
end

