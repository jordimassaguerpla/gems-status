require 'rubygems'
require 'gems_status_metadata'

class ViewResults

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
    <li> Update does gems that have been patched and are outdated
    </li>
    <li> Update does gems that are outdated
    </li>
    </ol>
    <p>
    After the comparison there are some checks that have been performed. Those checks imply also there is some kind of work to do
    </p>
    <p>
    You should run gems-status periodically until the lists of patched, outdated and checks are gone.
    </p>
    "
  end

  def ViewResults.print_diff(k, results, target)
    puts "<p>"
    puts "<table width='100%' class='table_results'>"
    version = results[target][k].version
    md5 = results[target][k].md5
    name_color = "info"
    html_string = ""
    results.each do |key, result|
      html_string << "<tr>"
      html_string << "<td>"
      html_string << "#{result[k].origin}"
      html_string << "</td>"
      html_string << "<td>"
      v_color = "info"
      md5_color = "info"
      if version != result[k].version then
        v_color = "warning"
        name_color = "warning" if name_color != "alert"
      else
        if md5 != result[k].md5 then
          md5_color = name_color = "alert"
        end
      end
      html_string << "<span class='#{v_color}'>"
      if !version then
        html_string << "error: look error log"
      end
      html_string << "#{result[k].version}"
      html_string << "</span>"
      html_string << "</td>"
      html_string << "<td>"
      html_string << "<span class='#{md5_color}'>"
      if result[k].md5.empty? then
        html_string << "error: look error log"
      end
      html_string << "#{result[k].md5}"
      html_string << "</span>"
      html_string << "</td>"
      html_string << "</tr>"
      version = result[k].version
      md5 = result[k].md5
    end
    puts "<tr><td><span class='#{name_color}'>#{k}</span></td></tr>"
    puts html_string
    puts "</table>"
    puts "</p>"
  end

  def ViewResults.print_check(description, name_gem)
      puts "<span class='check'> #{description}  #{name_gem}</span><br/>" 
  end
  
  def ViewResults.print_head
    puts "<html>
    <head>
    <style>
    body 
    {
    font-size: 100%;
    }
    h1
    {
    font-size: 110%;
    font-weight: bold;
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
    .check
    {
    font-style: italic;
    color: #ff0000;
    font-size: 80%;
    }
    .table_results
    {
    font-size: 80%;
    }
    </style>
    </head>
    <body>"
  end

  def ViewResults.print_tail
    date = Time.now.strftime('%F0')
    puts "<p class='footer'>run by <a href=\"https://github.com/jordimassaguerpla/gems-status\">gems-status</a> - #{date} - version: #{GemsStatusMetadata::VERSION}</p>
    </body>
    </html>"
  end

end
