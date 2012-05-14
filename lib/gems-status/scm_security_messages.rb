class ScmSecurityMessages
  def check_message?(msg)
    return msg.include?("security")
  end
end
