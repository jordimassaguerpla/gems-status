require "gems-status/checkers/scm_check_messages.rb"

module GemsStatus
  class ScmSecurityMessages
    def check_message?(msg)
      return msg =~ /\b(XSS|CSRF|cross-site|cross site|crosssite|injection|forgery|traversal|CVE|unsafe|vulnerab|risk|security|Malicious|DoS)\b/i 
    end
  end
end
