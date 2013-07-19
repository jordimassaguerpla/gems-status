require "openssl"
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
require "gmail"
require "rubygems/format"

module GemsStatus
  class Mail
    attr_accessor :uid, :subject
  end


  class Utils
    attr_accessor :errors
    EMAIL_TMP_PATH = "tmp/utils/mail"
    @@errors = {}
    @@md5_sums = {}
    @@licenses = {}
    @@keys = {}
    @@gems = {}
    @@known_licenses = {}
    @@emails = nil

    def Utils.get_emails_from_fs
      @@emails = {}
      Dir.glob("#{EMAIL_TMP_PATH}/**/*").each do |filename|
        next unless File.file?(filename)
        open(filename, "r") do |file|
          mail = GemsStatus::Mail.new
          mailing_list = File.dirname(filename).split("/").pop
          mail.uid = File.basename(filename)
          mail.subject = file.read
          
          if @@emails[mailing_list]
            @@emails[mailing_list] << mail
          else
            @@emails[mailing_list] = [mail]
          end
          self.log_debug "email from filesystem #{filename}"
        end
      end
    end

    def Utils.save_email_to_fs(listname, mail)
      dirname = "#{EMAIL_TMP_PATH}/#{listname}"
      filename = "#{dirname}/#{mail.uid}"
      if File.exists?(filename)
        self.log_debug "email had already been downloaded #{mail.uid} - skipping"
        return
      end
      Dir.mkdir(dirname)  unless File.exists?(dirname)
      open(filename, "w") do |f|
        self.log_debug "writing email to fs #{mail.uid}"
        f.write(mail.subject)
      end
    end

    def Utils.download_emails(email_username, email_password, mailing_lists)
      begin
        self.get_emails_from_fs if @@emails.nil?
      rescue Exception => e
        self.log_error "", "There was a problem getting emails from filesystem #{e.message}"
      end
      if @@emails.nil?
        self.log_error "", "There was a problem getting emails from filesystem"
        @@emails = {}
      end
      self.log_debug "Emails read from filesystem #{@@emails.to_a.flatten.length}"
      Gmail.new(email_username, email_password) do |gmail|
       mailing_lists.each do |mailing_list|
         @@emails[mailing_list] = [] unless @@emails[mailing_list]
         Utils::log_debug "New security email alerts from #{mailing_list} #{gmail.inbox.count( :unread, :to => mailing_list)}"
         gmail.inbox.emails(:unread, :to => mailing_list).each do |email|
           mail = GemsStatus::Mail.new
           mail.uid = email.uid
           mail.subject = email.subject
           Utils::log_debug "Read #{mail.subject}"
           @@emails[mailing_list] << mail
           begin
             self.save_email_to_fs(mailing_list, mail)
             email.read!
           rescue Exception => e
             self.log_error "", "Error saving mail to filesystem #{e.message}"
             email.unread!
           end
         end
       end
      end
      return @@emails
    end

    def Utils.known_licenses=(licenses)
      @@known_licenses = licenses
    end

    def Utils.known_licenses
      return @@known_licenses
    end

    def Utils.errors
      return @@errors
    end

    def Utils.check_parameters(classname, conf, parameters)
      if !conf['classname'] then
        raise "trying to initialize #{classname} when parameter classname does not exists"
      end
      if conf['classname'] != classname then
        raise "trying to initialize #{classname} when parameter classname is #{conf['classname']}"
      end
      parameters.each do |p|
        if !conf[p] then
          raise "parameter #{p} not found for #{classname}"
        end
      end
    end

    def Utils.log_error(name, msg)
      @@errors[name] = "\n" unless @@errors[name]
      @@errors[name]  << msg << "\n"
      $stderr.puts "ERROR: #{msg}"
    end

    def Utils.log_debug(msg)
      $stderr.puts "DEBUG: #{msg}"
    end

    def Utils.download_md5(name, version, gems_url)
      key = "#{name}-#{version}-#{gems_url.gsub("/", "_").gsub(":", "_")}"
      return @@md5_sums[key] if @@md5_sums[key]
      begin
        gem_file_path = self.download_gem(name, version, gems_url)
      rescue Exception => e
        self.log_error(name, e.message)
        return nil
      end
      md5 = Digest::MD5.hexdigest(open(gem_file_path).read)
      @@md5_sums["#{name}-#{version}"] = md5
      return md5
    end

    def Utils.download_license(name, version, gems_url)
      version = version.to_s if version.is_a? Gem::Version
      key = "#{name}-#{version}-#{gems_url.gsub("/", "_").gsub(":", "_")}"
      return @@licenses[key] if @@licenses[key]
      begin
        gem_file_path = self.download_gem(name, version, gems_url)
      rescue Exception => e
        self.log_error(name, e.message)
        return nil
      end
      license = Gem::Format.from_file_by_path(gem_file_path).spec.license
      if !license || license.empty?
        if @@known_licenses[name]
          if @@known_licenses[name][version]
            license = @@known_licenses[name][version]
            Utils::log_debug "get license from known licenses for #{name} #{version}"
          else #@@known_licenses[name] but different version
            Utils::log_debug "I can't find license for #{name} but I have info from another version #{@@known_licenses[name].sort.last}"
          end
        end
      end
      @@licenses[key] = license
      return license
    end

    def Utils.send_email(email_receiver, email_username, email_password, name, mssg)
        Gmail.new(email_username, email_password) do |gmail|
          gmail.deliver do
            to email_receiver
            subject "[gems-status] security alerts for #{name}"
            text_part do
               body mssg
             end
          end
        end
    end

    def Utils.download_date(name, version)
      Utils::log_debug "looking for date for #{name} - #{version}"
      begin
        versions = JSON.parse(open("https://rubygems.org/api/v1/versions/#{name}.json").read)
        versions.each do |v|
          if Gem::Version.new(v["number"]) == version
            Utils::log_debug  "Date for #{name} - #{version} : #{v["built_at"]}"
            return Time.parse v["built_at"]
          end
        end
      rescue
        Utils::log_error(name, "There was a problem opening https://rubygems.org/api/v1/versions/#{name}.json")
      end
      nil
    end

    private

    def Utils.download_gem(name, version, gems_url)
      gem_uri = URI.parse("#{gems_url}/#{name}-#{version}.gem")
      tmp_path = "tmp/utils/gems/#{gems_url.gsub("/", "_").gsub(":", "_")}/"
      gem_name = "#{name}-#{version}.gem"
      full_path = "#{tmp_path}/#{gem_name}"
      return full_path if File.exists? full_path
      uri_debug = gem_uri.clone
      uri_debug.password = "********" if uri_debug.password
      Utils::log_debug "download #{@name} from #{uri_debug}"
      FileUtils::mkdir_p(tmp_path) if ! File.exists?(tmp_path)
      if gem_uri.user && gem_uri.password
        source = open(gem_uri.scheme + "://" + gem_uri.host + "/" + gem_uri.path,
                     "rb",
                      :http_basic_authentication=>[gem_uri.user, gem_uri.password])
      else
        source = open(gem_uri)
      end
      open(full_path, "wb") do |file|
        file.write(source.read)
      end
      source.close
      return full_path
    end
  end
end
