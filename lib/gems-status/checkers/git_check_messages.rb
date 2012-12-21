require "git"

require "gems-status/checkers/scm_check_messages"

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
      g = Git.open(name)
    rescue
      g = Git.clone(source_repo, name)
    end
    g.pull
    return g.log MAX_NUM_MESSAGES
  end

  def commit_key(commit)
    return commit.sha
  end

  def date(commit)
    commit.date
  end

end
