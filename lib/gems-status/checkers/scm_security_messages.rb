class ScmSecurityMessages
  def check_message?(msg)
    return msg =~ /XSS|CSRF|cross-site|cross site|crosssite|injection|forgery|traversal|CVE|unsafe|vulnerab|risk|security|Malicious|DoS/i 
  end
end
