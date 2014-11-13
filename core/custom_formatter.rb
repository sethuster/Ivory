require 'rspec/core/formatters/html_formatter'

class CustomFormatter < RSpec::Core::Formatters::HtmlFormatter
  def extra_failure_content(failure)
    rand_id = rand(100000000..999999999)
    toggle_div_script = "if(!window.jquery_loaded){var script = document.createElement('script');script.src = 'https://ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js';document.getElementsByTagName('head')[0].appendChild(script); window.jquery_loaded=true;} $('#extra_#{rand_id}').toggle();"
    @html = "<a href='#' onclick=\"#{toggle_div_script}\">Show/Hide Details</a>"
    @html << "<div id='extra_#{rand_id}' style='display: none;'>"
    @html << "<table border='1'>"
    @html << "<th>Command Log</th>"
    $logger.log.each { |x| @html << '<tr><td style="color:' + x.color + '">' + x.text + '</td></tr>'  }
    @html << "</table><table border='1'><th>Test Artifacts</th>"
    @html << '<tr><td><img style="max-width:800px;" src="screenshot_' + RSpec.configuration.test_name + '.png"/></td></tr>'
    @html << '<tr><td><a href="screenshot_' + RSpec.configuration.test_name + '.html">Source Html</a></td></tr>'
    @html << '<tr><td><a href="output.txt">Documentation</a></td></tr>'

    if(RSpec.configuration.use_proxy)
    @html << '<tr><td><a href="'+ RSpec.configuration.test_name + '.har">HAR</a></td></tr>'
    end
    @html << '</span></table>'
    @html << "</div>"
    super + @html

  end

end