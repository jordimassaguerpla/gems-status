require "gems-status/checkers/scm_check_messages"

class SvnCheckMessages < ScmCheckMessages

private

  def message(commit)
    return commit
  end

  def messages(name, source_repo)
    if ! File.exists?(svn_dir(source_repo))
      `svn checkout #{source_repo}`
    end
    Dir.chdir(svn_dir(source_repo)) do
      `svn update`
      log_messages = `svn log`
      return log_messages.split("------------------------------------------------------------------------")
    end
  end

  def commit_key(commit)
    if commit.split("|").length == 0
      Utils::log_error("no key for commit #{commit}")
      return nil
    end
    return commit.split("|")[0].strip
  end

  def svn_dir(source_repo)
    source_repo_splitted = URI.parse(source_repo).path.split("/")
    return source_repo_splitted[-1]
  end
end
