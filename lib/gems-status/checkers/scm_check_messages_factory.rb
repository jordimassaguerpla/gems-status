require "gems-status/checkers/git_check_messages"
require "gems-status/checkers/hg_check_messages"
require "gems-status/checkers/svn_check_messages"
require "gems-status/utils"

module GemsStatus

  class ScmCheckMessagesFactory
     def self.get_instance(source_repo)
       if source_repo.include?("git")
         Utils::log_debug "git repo"
         GitCheckMessages.new 
       elsif source_repo.include?("svn")
         Utils::log_debug "svn repo"
         SvnCheckMessages.new
       elsif source_repo.include?("bitbucket")
         Utils::log_debug "mercurial repo"
         HgCheckMessages.new
       else
         nil
       end
     end
  end

end
