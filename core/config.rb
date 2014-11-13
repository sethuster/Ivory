require 'custom_formatter'
require 'j_unit_reporter'
require 'ruby_extensions'

#### ANY ENVIRONMENT SETUP FROM SHELL ####

# Use remote web driver, default false
ENV['REMOTE_DRIVER'] ||= "false"

#Used for sub-domaining
ENV['SUB'] ||= "qa03"

# Default Browser
ENV['BROWSER'] ||= "firefox"
#
ENV['DESKTOP_URL'] ||= "http://www.itriagehealth.com"
ENV['MOBILE_URL'] ||= "http://m.itriagehealth.com"


# With implicit waits enabled, use of wait_until methods is no longer required. This method will
# wait for the element to be found on the page until the Capybara default timeout is reached.
SitePrism.configure do |config|
  config.use_implicit_waits = true
end


#### Setup runtime configuration for rspec ####
browser = nil
host_platform = :any
host_version = ""
host_ip = "localhost"

element_wait_sec = 60
default_url = ENV['DESKTOP_URL']
remote_driver = Boolean(ENV['REMOTE_DRIVER'])

# setup the browser
ENV['BROWSER'] = ENV['BROWSER'].to_s.downcase.chomp
case ENV['BROWSER']
  when "firefox" then browser = Browsers::Firefox
  when "chrome" then browser = Browsers::Chrome
  when "safari" then browser = Browsers::Safari
  when "ie8"
    browser = Browsers::InternetExplorer
    host_version = "8"
  when "ie9"
    browser = Browsers::InternetExplorer
    host_version = "9"
  when "ie10"
    browser = Browsers::InternetExplorer
    host_version = "10"
  when "android" then browser = Browsers::Android
  when "iphone", "ipad"
    remote_driver = true  # mobile devices always need to use remote driver
    host_platform = :mac
    host_version = "7.1"  # ios sdk version
    element_wait_sec = 60
    browser = Browsers::IPad if ENV['BROWSER'].eql? "ipad"
    browser = Browsers::IPhone if ENV['BROWSER'].eql? "iphone"

    # ios devices think it's a phishing site if you use the ldap creds for the simple
    # http authentication. Test suites need to be ran in the OKL network
    default_url = ENV['MOBILE_URL']
end

# this is any ugly logical step to support remote driver and grid
if remote_driver.eql?(true) && !browser.eql?(Browsers::IPad) && !browser.eql?(Browsers::IPhone)
  # OKL selenium grid hub
  host_ip = "GRID URL"
end


#
# Reset capybara by removing cookies, resetting the session, and maximizing the browser window
#
def reset_capybara
  # reset the capybara session and configuration
  if (RSpec.configuration.default_browser != Browsers::IPhone) &&
      (RSpec.configuration.default_browser != Browsers::IPad)
    Capybara.reset_sessions!
  end

  Capybara.configure do |config|
    config.match = :prefer_exact
    config.exact = false
    config.ignore_hidden_elements = false
    config.visible_text_only = true
    config.default_wait_time = RSpec.configuration.element_wait_sec
  end

  # delete cookies and maximize browser for only desktop browsers
  if (RSpec.configuration.default_browser != Browsers::IPhone) &&
      (RSpec.configuration.default_browser != Browsers::IPad)
    # Delete some cookies for the site that are hanging around
    page.driver.browser.manage.delete_cookie('ewokAuth')
    page.driver.browser.manage.delete_cookie('ewokAuthGuestPass')
    page.driver.browser.manage.delete_cookie('keepLogin')
    page.driver.browser.manage.delete_cookie('is_member')

    # Ensure the browser is maximized to maximize visibility of element
    # Currently doesn't work with chromedriver
    page.driver.browser.manage.window.maximize

    # Chrome Hack to maximize window
    if RSpec.configuration.default_browser.eql?(:chrome)
      width = page.driver.browser.execute_script("return screen.width;")
      height = page.driver.browser.execute_script("return screen.height;")
      page.driver.browser.manage.window.move_to(0,0)
      page.driver.browser.manage.window.resize_to(width,height)
    end
  end
end


#### RSPEC CONFIGURATION ###
RSpec.configure do |config|
  config.include Capybara::DSL
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.add_setting :default_browser, :default => browser
  config.add_setting :remote_driver, :default => remote_driver
  config.add_setting :host_ip, :default => host_ip
  config.add_setting :host_platform, :default=>host_platform
  config.add_setting :host_version, :default=>host_version
  config.add_setting :host_port, :default => 4444
  config.add_setting :page_load_timeout, :default => 60
  config.add_setting :element_wait_sec, :default => element_wait_sec
  config.add_setting :screenshot_on_failure, :default => true
  config.add_setting :command_logging, :default => true
  config.add_setting :default_url, :default => default_url
  config.add_setting :ldap_username, :default => ""
  config.add_setting :ldap_user_password, :default =>""
  config.add_formatter :documentation,'output.txt'
  config.add_formatter CustomFormatter,'output.html'
  config.add_formatter JUnitReporter,'output.xml'
  config.add_setting :test_name, :default=>'Test'
  config.add_setting :command_delay_sec, :default=>0
  config.add_setting :browsermob_path, :default=>'C:\Users\SethUrban\Documents\GitHub\Grolem\browsermob-proxy\bin\browsermob-proxy.bat'
  config.add_setting :use_proxy, :default=>false
  config.add_setting :proxy_server_port, :default=>8080
  config.add_setting :proxy_port, :default=>9091
  config.add_setting :proxy_host, :default=>'localhost'
  config.add_setting :less_verbose_logging, :default => true


  config.before(:each) do
    reset_capybara

    $logger = CommandLogger.new
    path = example.metadata[:description]
    config.test_name = path
    $logger.Log "Starting  #{config.test_name}"
  end

  config.after(:each) do
    if RSpec.configuration.use_proxy
      har = $proxy.har
      entries = har.entries
      har.save_to (RSpec.configuration.test_name+ '.har')
      $proxy.close
    end
      if example.exception.is_a? Timeout::Error
        # restart Selenium driver
        Capybara.send(:session_pool).delete_if { |key, value| key =~ /selenium/i }
      end
    end

  config.before(:all) do
    reset_capybara

    if RSpec.configuration.use_proxy && RSpec.configuration.default_browser == Browsers::Firefox
      server = BrowserMob::Proxy::Server.new(RSpec.configuration.browsermob_path) #=> #<BrowserMob::Proxy::Server:0x000001022c6ea8 ...>
      server.start
      $proxy = server.create_proxy
    end
    $logger = CommandLogger.new
    $logger.Log "Starting tests on #{RSpec.configuration.default_url}"
  end

  config.after(:all) do
  end

end



