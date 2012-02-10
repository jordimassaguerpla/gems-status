require "rubygems"
require "xmlsimple"
require "open-uri"

require "gem_simple"
require "gems_command"
require "utils"

class OBSGems < GemsCommand
  FILES_TO_IGNORE = /(\w(\.gem|\.spec|\.changes|\.rpmlintrc|-rpm-lintrc|-rpmlintrc))|README.SuSE/
  def initialize(conf)
    Utils::check_parameters('OBSGems', conf, ["id", "username", "password", "url", "obs_repo"])
    @result = {}
    @username = conf['username']
    @password = conf['password']
    @obs_url = conf['url']
    @repo = conf['obs_repo']
    @ident = conf['id']

  end

  def parse_link(linkinfo)
    if linkinfo.length > 1 then
      Utils::log_error("?", "There is more than one linkinfo element")
      return
    end
    if !linkinfo[0]["project"] then
      Utils::log_error("?", "Project element does not exists in linkinfo")
      return
    end
    if !linkinfo[0]["package"] then
      Utils::log_error("?", "Package element does not exists in linkinfo")
      return
    end
    repo = linkinfo[0]["project"]
    package = linkinfo[0]["package"]
    if linkinfo[0]["rev"] then
      rev = linkinfo[0]["rev"]
      Utils::log_debug "Revision in link: #{rev}."
      package = package + "?rev=" + rev
    end
    Utils::log_debug "follow link to project: #{repo} package: #{package}"
    parse_rpm_data(repo, package)
  end

  def get_data(package, url)
    data = ""
    begin
      data = open(url, :http_basic_authentication => [@username, @password]).read
    rescue
      Utils::log_error(package.sub("rubygem-",""), "There was a problem opening #{url} ")
    end
    return data 
  end

  def parse_rpm_data(project, package)
    url = @obs_url + "/" + project
    rpm_url = url + "/" + package
    response = get_data(package, rpm_url) 
    if response.empty? then
      return
    end
    data = XmlSimple.xml_in(response)
    if data["linkinfo"] then
      Utils::log_debug "#{data["name"]} is a link."
      if data["entry"].length != 1
        msg = " "
        data["entry"].each {|e| msg << " " << e["name"]}
        Utils::log_error(package.sub("rubygem-",""), "when parsing the link for #{project} : #{package}. There are more entries than expected. That may be a patched link and the result may not be correct:" + msg)
      end
      parse_link(data["linkinfo"])
      return
    end
    if !data["entry"] then
      Utils::log_error(package.sub("rubygem-",""), "something went wrong retrieving info from #{project} : #{package}")
      return
    end
    data["entry"].each do |entry|
      if !(entry["name"] =~ OBSGems::FILES_TO_IGNORE)
        Utils::log_error(package.sub("rubygem-",""), "when parsing data for #{project} : #{package}. Entry not expected. That may be a patched rpm and the result may not be correct. #{entry["name"]} ")
      end
      if entry["name"].end_with?(".gem") then
        name = gem_name(entry['name'])
        version = Gem::Version.new(gem_version(entry['name']))
        md5 = entry['md5']
        if !@result[name] || @result[name].version < version    
          @result[name] = GemSimple.new(name, version, md5, url)
        end
      end
    end
  end

  def execute
    url = @obs_url + "/" + @repo
    response = get_data("?", url)
    if response.empty? then
      return
    end
    data = XmlSimple.xml_in(response)
    data["entry"].each do |entry|
      entry.each do |k,v|
        if k == "name" and v.start_with?("rubygem-") then
          parse_rpm_data(@repo, v)
        end
      end
    end
  end

end
