class ScmCheckMessages
  MAX_RETRIES = 3

  def check_messages(name, source_repo, message_checker, origin, counter = 0)
    begin
      messages = messages(name, source_repo)
      return security_alerts(name, messages, message_checker, origin)
    rescue => e
      if counter == MAX_RETRIES
        Utils::log_error name, "There was a problem checking out #{source_repo} #{e}"
        return {}
      else
        Utils::log_debug "There was a problem checking out  #{source_repo} #{e}: Trying it again..."
        return check_messages(name, source_repo, message_checker, origin, counter + 1)
      end
    end
  end

private

  def security_alerts(name, commits, message_checker, origin)
    results = {}
    commits.each do |commit|
      if message_checker.check_message?(message(commit))
        Utils::log_debug "#{message(commit)}"
        key = "#{name}_#{origin}_#{commit_key(commit)}"
        if !key
          Utils::log_error "no key for #{name}"
          next
        end
        Utils::log_debug "security key: #{key}"
        results[key] = message(commit)
      end
    end
    return results
  end

  def commit_key(commit)
    raise NotImplementedError
  end

  def message(commit)
    raise NotImplementedError 
  end

  def messages(name, source_repo)
    raise NotImplementedError 
  end
end
