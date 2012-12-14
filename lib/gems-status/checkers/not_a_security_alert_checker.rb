require "gmail"
require "json"
require "open-uri"

require "gems-status/checkers/gem_checker"
require "gems-status/checkers/git_check_messages"
require "gems-status/checkers/hg_check_messages"
require "gems-status/checkers/svn_check_messages"
require "gems-status/checkers/scm_security_messages"

class NotASecurityAlertChecker < GemChecker
  def initialize(conf)
    Utils::check_parameters('NotASecurityAlertChecker', conf, ["fixed", "source_repos", "email_username", "email_password", "mailing_lists", "email_to"])
    begin
      @fixed = YAML::load(File::open(conf["fixed"]))
    rescue
      Utils::log_error("?", "There was a problem opening #{conf["fixed"]}")
      @fixed = []
    end
    @source_repos = conf["source_repos"]
    @security_messages = {}
    @email_username = conf["email_username"]
    @email_password = conf["email_password"]
    @mailing_lists = conf["mailing_lists"]
    @email_to = conf["email_to"]
    @emails = {}
    download_emails
  end

  def download_emails
    #TODO: only download new emails and keep the old ones in a database
     #puts "Security email alerts from #{mailing_list} #{gmail.inbox.count(:unread, :to => mailing_list}"
    Gmail.new(@email_username, @email_password) do |gmail|
     @mailing_lists.each do |mailing_list|
       @emails[mailing_list] = []
       Utils::log_debug "Security email alerts from #{mailing_list} #{gmail.inbox.count( :to => mailing_list)}"
       #TODO: only read new emails
       #gmail.inbox.emails(:unread, :to => "rubyonrails-security@googlegroups.com").each do |email|
       gmail.inbox.emails(:to => mailing_list).each do |email|
         Utils::log_debug "Read #{email.subject}"
         @emails[mailing_list] << email
       end
      end
    end
  end

  def send_emails(gem)
    return if @security_messages.length == 0
    #gems.origin == gems.gems_url if we are looking to an upstream gem, 
    #for example in rubygems.org. We only care about our application gems.
    return if gem.origin == gem.gems_url
    mssg = ""
    mssg = "#{gem.name} #{gem.version} : #{gem.origin} \n"
    @security_messages.each do |k,v|
      mssg = mssg + "\n #{v}"
      mssg = mssg + "\nFixed in #{@fixed[k]}\n" if @fixed[k]
    end
    @email_to.each do |email_receiver|
      Gmail.new(@email_username, @email_password) do |gmail|
        gmail.deliver do
          to email_receiver
          subject "[gems-status] security alerts for #{gem.name}"
          text_part do
             body mssg
           end
        end
      end
    end
    Utils::log_debug "Email sent to #{@email_to} "
    Utils::log_debug "with body #{mssg} "
  end

  def look_in_scm(gem)
    version = gem.version
    source_repo = source_repo(gem)
    if ! source_repo
      Utils::log_error gem.name, "Not source URL for #{gem.name}"
      return 
    end
    Utils::log_debug "Source URL for #{gem.name} #{source_repo}"
    look_for_security_messages(gem.name, source_repo, gem.origin)
  end

  def key_for_emails(listname, gem, email)
    "email_#{listname}_#{gem.name}_#{gem.origin}_#{email.uid}"
  end

  def match_name(str, name)
    str =~ /\b#{name}\b/
  end

  def look_in_emails(gem)
    @emails.each do |listname, emails|
      emails.each do |email|
        if match_name(listname, gem.name)
          @security_messages[key_for_emails(listname, gem, email)] = email.subject
          Utils::log_debug "looking for security emails: listname matches gem #{gem.name}: #{listname}"
          next
        end
        if match_name(email.subject, gem.name)
          @security_messages[key_for_emails(listname, gem, email)] = email.subject
          Utils::log_debug "looking for security emails: subject matches gem #{gem.name}: #{email.subject}"
          next
        end
      end
    end
  end

  def check?(gem)
    #ignore upstream checks
    return true if gem.origin == gem.gems_url

    @security_messages = {}
    look_in_scm(gem)
    look_in_emails(gem)
    filter_security_messages_already_fixed(gem.version)
    send_emails(gem)
    return @security_messages.length == 0
  end

 def description
   result = ""
   @security_messages.keys.sort.each do |k|
     result = result + "[#{k}] - #{@security_messages[k]}"
     result = result + "Fixed in #{@fixed[k]}" if @fixed[k]
     result = result + "<br/>" 
   end
   result = "Security alerts: #{result}" if result!=""
   return result
 end

 private

 def filter_security_messages_already_fixed(version)
   #TODO: let's use a database instead of having the info in yaml file
   #TODO: can we know which commits are in a particular version? by date?
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

 def look_for_security_messages(name, source_repo, origin, counter = 0)
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
                                        ScmSecurityMessages.new, origin)
      end
    end
 end

end
