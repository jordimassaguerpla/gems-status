require "rubygems"
require "xmlsimple"
require "open-uri"

require "gem_simple"
require "gems_command"
require "utils"

class OBSGems < GemsCommand
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
      $stderr.puts "ERROR: There is more than one linkinfo element"
      return
    end
    if !linkinfo[0]["project"] then
      $stderr.puts "ERROR: Project element does not exists in linkinfo"
      return
    end
    if !linkinfo[0]["package"] then
      $stderr.puts "ERROR: Package element does not exists in linkinfo"
      return
    end
    repo = linkinfo[0]["project"]
    package = linkinfo[0]["package"]
    if linkinfo[0]["rev"] then
      rev = linkinfo[0]["rev"]
      $stderr.puts "DEBUG: Revision in link: #{rev}."
      package = package + "?rev=" + rev
    end
    $stderr.puts "DEBUG: follow link to project: #{repo} package: #{package}"
    parse_rpm_data(repo, package)
  end

  def get_data(url)
    data = ""
    begin
      data = open(url, :http_basic_authentication => [@username, @password]).read
    rescue
      $stderr.puts "ERROR: There was a problem opening #{url} " 
    end
    return data 
  end

  def parse_rpm_data(project, package)
    url = @obs_url + "/" + project
    rpm_url = url + "/" + package
    response = get_data(rpm_url) 
    if response.empty? then
      return
    end
    data = XmlSimple.xml_in(response)
    if data["linkinfo"] then
      $stderr.puts "DEBUG: #{data["name"]} is a link."
      if data["entry"].length != 1
        $stderr.puts "ERROR: when parsing the link for #{project} : #{package}. There are more entries than expected. That may be a patched link and the result may not be correct"
      end
      parse_link(data["linkinfo"])
      return
    end
    if !data["entry"] then
      $stderr.puts "ERROR: something went wrong retrieving info from #{project} : #{package}"
      return
    end
    data["entry"].each do |entry|
      if !(entry["name"] =~ /\w\.(gem|spec|changes|rpmlintrc)/)
        $stderr.puts "ERROR: when parsing data for #{project} : #{package}. Entry not expected. That may be a patched rpm and the result may not be correct. #{entry["name"]}"
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
    response = get_data(url)
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
