require 'rubygems'
require 'gems-status/gems_status_metadata'
require 'gems-status/utils'

class ViewResults
  @@patched = []
  @@outdated = []
  @@up_to_date = []

  def ViewResults.print_description(ids)
    puts "
    <h1>gems-status</h1>
    <p>This is a comparison between different gem sources:</p>
    <ul>"
    ids.each { |id| puts "<li>#{id}</li>" }
   puts "</ul> 
    </p>
    <p>The following table gives you an overview of:</p>
    <ul>
    <li>
    <span class='alert'>patched</span>: gems that have same version but different md5sums
    </li>
    <li>
    <span class='warning'>outdated</span>: gems that have different versions on the different sources
    </li>
    <li>
    <span class='info'>up to date</span>: gems that are up to date in all the sources</span>
    </li>
    </ul>
    <p>
    Note that gems can be patched and outdated at the same time.
    </p>
    <p>
    This information should help you decide which should be your next steps.
    </p>
    <ol>
    <li> Maintain those gems that have been patched but are not outdated
    </li>
    <li> Update those gems that have been patched and are outdated
    </li>
    <li> Update those gems that are outdated
    </li>
    </ol>
    <p>
    After the comparison there are some checks that have been performed, errors related and comments. Look those results as they imply there is some kind of work to do
    </p>
    <p> At the end there are the errors, checks and comments that do not apply to any of the gems. Look them carefully.
    </p>
    <p>
    There is a summary at the end.
    </p>
    You should run gems-status periodically until the lists of errors, patched, outdated and checks are gone.
    </p>
    "
  end

  def ViewResults.update_summary(gem_name, status)
    if status == "alert"
      @@patched << gem_name
    elsif status == "warning"
      @@outdated << gem_name
    else
      @@up_to_date << gem_name
    end
  end

  def ViewResults.print_results(k, results, target, checker_results, comments)
    puts "<p>"
    puts "<table width='100%' class='table_results'>"
    version = results[target][k][0].version
    md5 = results[target][k][0].md5
    name_color = "info"
    html_string = ""
    results.each do |key, result|
      if !result[k]
        next
      end
      v_color = "info"
      md5_color = "info"
      result[k].each do |gem|
        html_string << "<tr>"
        html_string << "<td>"
        html_string << "#{gem.origin}"
        html_string << "</td>"
        html_string << "<td>"
        if gem.from_git? then
          md5_color = name_color = "alert"
        end
        if version != gem.version then
          v_color = "warning"
          name_color = "warning" if name_color != "alert"
        else
          if !gem.md5 || md5 != gem.md5 then
            md5_color = name_color = "alert"
          end
        end
        html_string << "<span class='#{v_color}'>"
        if !version then
          html_string << "error: look error log"
        end
        html_string << "#{gem.version}"
        html_string << "</span>"
        html_string << "</td>"
        html_string << "<td>"
        html_string << "<span class='#{md5_color}'>"
        if !gem.md5 || gem.md5.empty? then
          if gem.from_git? then
            html_string << "this comes from #{gem.gems_url}"
          else
            html_string << "error: look error log"
          end
        end
        html_string << "#{gem.md5}"
        html_string << "</span>"
        html_string << "</td>"
        html_string << "</tr>"
        version = gem.version
        md5 = gem.md5
      end
    end
    puts "<tr><td width='50%'><span class='#{name_color}'><a name=\"#{k}\" />#{k}</span></td><td width='10%'>version</td><td width='40%'>md5</td></tr>"
    puts html_string
    update_summary(k, name_color)
    puts "</table>"
    puts "</p>"
    if checker_results
      puts "<p> <span class='check'>checks:"
      puts "<br/>#{checker_results}</span>" 
      puts "</p>"
    end
    if Utils::errors[k]
      puts "<p><span class='errors'>errors: "
      puts "<br/>#{Utils::errors[k]}</span>" 
      Utils.errors.delete(k)
      puts "</p>"
    end
    if comments
      puts "<p><span class='comment'>comments: "
      puts "<br/>#{comments}</span>" 
      puts "</p>"
    end
  end

  def ViewResults.print_head
    puts "<html>
    <head>
    <style>
    body 
    {
    font-size: 90%;
    }
    h1
    {
    font-size: 110%;
    font-weight: bold;
    }
    h2
    {
    font-size: 100%;
    font-style: italic;
    font-weight: normal;
    }
    .gem_name
    {
    color: #000000;
    font-weight: bold;
    }
    .alert
    {
    color: #ff0000;
    }
    .warning
    {
    color: #ffaa00;
    }
    .info
    {
    color: #000000;
    }
    .info
    {
    color: #000000;
    }
    .footer
    {
    color: #aaaaaa;
    font-size: 60%;
    }
    .errors
    {
    color: #ff0000;
    font-size: 100%;
    font-style: italic;
    }
    .check
    {
    color: #a0a0a0;
    font-size: 100%;
    font-style: italic;
    }
    .comment
    {
    color: #a0a0a0;
    font-size: 100%;
    font-style: italic;
    }
    .table_results
    {
    font-size: 80%;
    }
    </style>
    </head>
    <body>"
  end

  def ViewResults.print_hash(desc, data, style, anchor = false)
    return if !data or data.length == 0
    puts "<p>"
    puts "<h2>#{desc}: #{data.length}</h2>"
    data.each do |k,v| 
      if anchor
        puts "<a href=\"\##{k}\"><span class='#{style}'>#{k}</span></a>"
      else
        puts "<span class='#{style}'>#{k}</span>"
      end
      puts "<span class='#{style}'> #{v}</span><br/>"

    end
    puts "</p>"
  end

  def ViewResults.print_summary
    puts "<a name='summary'/><h1>Summary</h1>"
    puts "<p><h2>patched/errored</h2>"
    puts "<ul>"
    @@patched.each do |p|
      puts "<li><a href=\"\##{p}\">#{p}</a>"
    end
    puts "</ul></p>"
    puts "<p><h2>outdated #{@@outdated.length}</h2>"
    @@outdated.each do |p|
      puts "<li><a href=\"\##{p}\">#{p}</a>"
    end
    puts "</ul></p>"
    puts "<p> <h2>up-to-date #{@@up_to_date.length}</h2>"
    @@up_to_date.each do |p|
      puts "<li><a href=\"\##{p}\">#{p}</a>"
    end
    puts "</ul></p>"
  end

  def ViewResults.print_tail(checker_results, comments)
    puts "<h1>Others</h1>"
    self.print_hash("comments", comments, "comment")
    self.print_hash("errors", Utils::errors, "errors")
    self.print_summary
    self.print_hash("checks", checker_results, "summary", true)
    date = Time.now.strftime('%a %b %d %H:%M:%S %Z %Y')
    puts "<p class='footer'>run by <a href=\"https://github.com/jordimassaguerpla/gems-status\">gems-status</a> - #{date} - version: #{GemsStatusMetadata::VERSION}</p>
    </body>
    </html>"
  end

end
