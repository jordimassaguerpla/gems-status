require "git"

require "gems-status/scm_check_messages"

class GitCheckMessages < ScmCheckMessages

private

  def message(commit)
    return commit.message
  end

  def messages(name, source_repo)
    begin
      g = Git.open(name)
    rescue
      g = Git.clone(source_repo, name)
    end
    g.pull
    return g.log
  end

  def commit_key(commit)
    return commit.sha
  end

end
