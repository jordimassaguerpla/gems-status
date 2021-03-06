require "json"
require "open-uri"

require "gems-status/checkers/gem_checker"
require "gems-status/checkers/security_alert"
require "gems-status/checkers/scm_security_messages"
require "gems-status/checkers/scm_check_messages_factory"

module GemsStatus

  class NotASecurityAlertChecker < GemChecker
    attr_reader :security_messages, :gem
    def initialize(conf)
      Utils::check_parameters('NotASecurityAlertChecker', conf, ["fixed", "source_repos", "email_username", "email_password", "mailing_lists", "email_to"])
      @fixed = conf["fixed"]
      @source_repos = conf["source_repos"]
      @security_messages = {}
      @email_username = conf["email_username"]
      @email_password = conf["email_password"]
      @mailing_lists = conf["mailing_lists"]
      @email_to = conf["email_to"]
      @emails = {}
      @gem = nil
      @emails = Utils.download_emails(@email_username, @email_password, @mailing_lists)
    end

    def check?(gem)
      @gem = gem
      #ignore upstream checks
      return true if gem.origin == gem.gems_url

      @security_messages = {}
      look_in_scm(gem)
      look_in_emails(gem)
      filter_security_messages_already_fixed(gem.version, gem.date)
      send_emails(gem)
      return @security_messages.length == 0
    end

   def description
     if !@gem
       Utils::log_debug("No gem. That means that check method has not been called in NotASecurityAlertChecker")
       return
     end
     message(@gem)
   end

   private

    def match_name(str, name)
      str =~ /(gem|ruby).*\b#{name}\b/ || str =~ /\b#{name}\b.*(gem|ruby).*/
    end

    def message(gem)
      return unless gem
      mssg = ""
      mssg = "#{gem.name} #{gem.version} : #{gem.origin} \n"
      @security_messages.each do |k,v|
        mssg = mssg + "\n-- #{k} --"
        mssg = mssg + "\n #{v.desc}"
        mssg = mssg + "\nFixed in #{@fixed[k]}\n" if @fixed[k]
      end
      mssg
    end

    def send_emails(gem)
      return if @security_messages.length == 0
      #gems.origin == gems.gems_url if we are looking to an upstream gem, 
      #for example in rubygems.org. We only care about our application gems.
      #where the origin will be a gemfile.lock file
      return if gem.origin == gem.gems_url
      mssg = message(gem)
      @email_to.each do |email_receiver|
        GemsStatus::Utils.send_email(email_receiver, @email_username,
                                     @email_password, gem.name, mssg)
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

    def look_in_emails(gem)
      @emails.each do |listname, emails|
        emails.each do |email|
          if listname.strip == "rubyonrails-security@googlegroups.com" && gem.name == "rails" 
            @security_messages[key_for_emails(listname, gem, email)] = SecurityAlert.new(email.subject)
            Utils::log_debug "looking for security emails: listname matches gem #{gem.name}: #{listname}"
          elsif email.subject.start_with? "Re:"
            Utils::log_debug "ignoring message that starts with Re:"
          elsif match_name(email.subject, gem.name)
            @security_messages[key_for_emails(listname, gem, email)] = SecurityAlert.new(email.subject)
            Utils::log_debug "looking for security emails: subject matches gem #{gem.name}: #{email.subject}"
          end
        end
      end
    end

   def filter_security_messages_already_fixed(version, date)
     @security_messages.delete_if do |k,v|
       @fixed[k] && Gem::Version.new(@fixed[k]) <= version 
     end
     @security_messages.delete_if do |k,v|
       v.date && date && v.date < date
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
     gem_uri(gem_version_information)
   end

   def look_for_security_messages(name, source_repo, origin, counter = 0)
      Utils::log_debug "looking for security messages on #{source_repo}"
      if ! File.exists?("build_security_messages_check")
        Utils::log_debug "creating build_security_messages_check in #{Dir.pwd}"
        Dir.mkdir("build_security_messages_check")
      end
      Dir.chdir("build_security_messages_check") do
        if ! File.exists?(name)
          Dir.mkdir(name)
        end
        Dir.chdir(name) do
          scmCheckMessages = ScmCheckMessagesFactory.get_instance(source_repo)
          if scmCheckMessages == nil
            Utils::log_error name, "Not a valid source repo #{source_repo}"
            return {}
          end
          @security_messages = scmCheckMessages.check_messages(name, source_repo, 
                                          ScmSecurityMessages.new, origin)
        end
      end
   end

   def gem_uri(gem_version_information)
     if gem_version_information["project_uri"] && 
        gem_version_information["project_uri"].include?("github")
       return gem_version_information["project_uri"]
     elsif gem_version_information["homepage_uri"] && 
        gem_version_information["homepage_uri"].include?("github")
       return gem_version_information["homepage_uri"]
     elsif gem_version_information["source_code_uri"] && 
        gem_version_information["source_code_uri"].include?("github")
       return gem_version_information["source_code_uri"]
     else
       return nil
     end
   end

  end
end
