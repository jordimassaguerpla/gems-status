require "json"
require "open-uri"

require "gems-status/gem_checker"
require "gems-status/git_check_messages"
require "gems-status/hg_check_messages"
require "gems-status/svn_check_messages"
require "gems-status/scm_security_messages"

class NotASecurityAlertChecker < GemChecker
  def initialize(conf)
    Utils::check_parameters('NotASecurityAlertChecker', conf, ["fixed", "source_repos"])
    @fixed = conf["fixed"]
    @source_repos = conf["source_repos"]
    @security_messages = {}
  end

  def check?(gem)
    @security_messages = {}
    version = gem.version
    source_repo = source_repo(gem)
    if ! source_repo
      Utils::log_error gem.name, "Not source URL for #{gem.name}"
      return true
    end
    Utils::log_debug "Source URL for #{gem.name} #{source_repo}"
    look_for_security_messages(gem.name, source_repo)
    filter_security_messages_already_fixed(gem.version)
    return @security_messages.length == 0
  end

 def description
   result = ""
   @security_messages.keys.sort.each do |k|
     result = result + "[#{k}] - #{@security_messages[k]}<br/>"
   end
   result = "Security alerts:" + result if result!=""
   return result
 end

 private

 def filter_security_messages_already_fixed(version)
   @security_messages.delete_if do |k,v|
     @fixed[k] && Gem::Version.new(@fixed[k]) <= version 
   end
 end

 def source_repo(gem)
   if @source_repos[gem.name]
     return @source_repos[gem.name]
   end
   begin
     gem_version_information = JSON.parse(open("http://rubygems.org/api/v1/gems/#{gem.name}.json").read)
   rescue => e
     Utils::log_error gem.name, "There was a problem downloading info for #{gem.name} #{e.to_s}"
     return nil
   end
   uri = nil
   if gem_version_information["project_uri"] && 
      gem_version_information["project_uri"].include?("github")
     uri = gem_version_information["project_uri"]
   end
   if gem_version_information["homepage_uri"] && 
      gem_version_information["homepage_uri"].include?("github")
     uri = gem_version_information["homepage_uri"]
   end
   if gem_version_information["source_code_uri"] && 
      gem_version_information["source_code_uri"].include?("github")
     uri = gem_version_information["source_code_uri"]
   end
   return uri
 end

 def look_for_security_messages(name, source_repo, counter = 0)
    Utils::log_debug "looking for security messages on #{source_repo}"
    if ! File.exists?("build_security_messages_check")
      Dir.mkdir("build_security_messages_check")
    end
    Dir.chdir("build_security_messages_check") do
      if ! File.exists?(name)
        Dir.mkdir(name)
      end
      Dir.chdir(name) do
        if source_repo.include?("git")
          scmCheckMessages = GitCheckMessages.new 
          Utils::log_debug "git repo"
        elsif source_repo.include?("svn")
          scmCheckMessages = SvnCheckMessages.new
          Utils::log_debug "svn repo"
        elsif source_repo.include?("bitbucket")
          scmCheckMessages = HgCheckMessages.new
          Utils::log_debug "mercurial repo"
        else
          Utils::log_error name, "Not a valid source repo #{source_repo}"
          return {}
        end
        @security_messages = scmCheckMessages.check_messages(name, source_repo, 
                                        ScmSecurityMessages.new)
      end
    end
 end

end
