require "rubygems"
require "xmlsimple"
require "open-uri"

require "gem_simple"
require "gems_command"

class OBSGems < GemsCommand
  def check_parameters(conf)
    if !conf['classname'] then
      puts "ERROR: trying to initialize OBSGem when parameter classname does not exists"
      exit
    end
    if conf['classname'] != "OBSGems" then
      puts "ERROR: trying to initialize OBSGems when parameter classname is #{conf['classname']}"
      exit
    end
    if !conf['username'] then
      puts "ERROR: parameter username not found for OBSGems"
      exit
    end
    if !conf['password'] then
      puts "ERROR: parameter password not found for OBSGems"
      exit
    end
    if !conf["url"] then
      puts "ERROR: parameter url not found for OBSGems"
      exit
    end
    if !conf["obs_repo"] then
      puts "ERROR: parameter obs_repo not found for OBSGems"
      exit
    end
  end

  def initialize(conf)
    check_parameters(conf)
    @result = {}
    @username = conf['username']
    @password = conf['password']
    @obs_url = conf['url']
    @repo = conf['obs_repo']

  end

  def parse_link(linkinfo)
    if linkinfo.length > 1 then
      puts "ERROR: There is more than one linkinfo element"
      return
    end
    if !linkinfo[0]["project"] then
      puts "ERROR: Project element does not exists in linkinfo"
      return
    end
    if !linkinfo[0]["package"] then
      puts "ERROR: Package element does not exists in linkinfo"
      return
    end
    repo = linkinfo[0]["project"]
    package = linkinfo[0]["package"]
    if linkinfo[0]["rev"] then
      rev = linkinfo[0]["rev"]
      puts "DEBUG: Revision in link: #{rev}."
      package = package + "?rev=" + rev
    end
    puts "DEBUG: follow link to project: #{repo} package: #{package}"
    parse_rpm_data(repo, package)
  end

  def get_data(url)
    return open(url, :http_basic_authentication => [@username, @password]).read
  end

  def parse_rpm_data(project, package)
    url = @obs_url + "/" + project
    rpm_url = url + "/" + package
    response = get_data(rpm_url) 
    data = XmlSimple.xml_in(response)
    if data["linkinfo"] then
      puts "DEBUG: #{data["name"]} is a link."
      parse_link(data["linkinfo"])
      return
    end
    if !data["entry"]
      puts "ERROR: something went wrong retrieving info from #{project} : #{package}"
      return
    end
    data["entry"].each do |entry|
      if entry["name"].end_with?(".gem") then
        name = gem_name(entry['name'])
        version = gem_version(entry['name'])
        md5 = entry['md5']
        @result[name] = GemSimple.new(name, version, md5, url)
      end
    end
  end

  def execute
    url = @obs_url + "/" + @repo
    response = get_data(url)
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
