module Browsers
  Firefox = :firefox
  Chrome = :chrome
  Safari = :safari
  InternetExplorer = :ie
  Android = :android
  IPhone = :iphone
  IPad = :ipad

  #:browser_name          => "",
  #    :version               => "",
  #    :platform              => :any,
  #    :javascript_enabled    => false,
  #:css_selectors_enabled => false,
  #:takes_screenshot      => false,
  #:native_events         => false,
  #:rotatable             => false,
  #:firefox_profile       => nil,
  #:proxy                 => nil
  def setup_browser
    $logger.Log "SetDefaultBrowser: #{RSpec.configuration.default_browser}"
    Capybara.register_driver :selenium do |app|
      if RSpec.configuration.use_proxy
        $logger.Log "Using BMP Proxy"
        profile = Selenium::WebDriver::Firefox::Profile.new
        profile.proxy = $proxy.selenium_proxy
        $proxy.new_har RSpec.configuration.test_name
        profile = Selenium::WebDriver::Firefox::Profile.new
        profile["network.proxy.type"] = 1 # manual proxy config
        profile["network.proxy.http"] = RSpec.configuration.proxy_host
        profile["network.proxy.http_port"] = RSpec.configuration.proxy_port
        driver = Capybara::Selenium::Driver.new(app,  :browser => RSpec.configuration.default_browser,:profile => profile)
      else
        $logger.Log "Starting #{RSpec.configuration.default_browser} Browser"
        driver = Capybara::Selenium::Driver.new(app, :browser => RSpec.configuration.default_browser)
      end
      if RSpec.configuration.remote_driver
        client = Selenium::WebDriver::Remote::Http::Default.new
        client.timeout = 120 # seconds
        $logger.Log "Starting Remote Test on Host: '#{RSpec.configuration.host_ip}', Browser: '#{RSpec.configuration.default_browser}', Version : '#{RSpec.configuration.host_version}' OS: '#{RSpec.configuration.host_platform}'. "
        case RSpec.configuration.default_browser
          when :firefox
            capabilities = Selenium::WebDriver::Remote::Capabilities.firefox(
                :platform=>RSpec.configuration.host_platform,
                :version=>RSpec.configuration.host_version,
                :url=>"http://#{RSpec.configuration.host_ip}:#{RSpec.configuration.host_port}/wd/hub")
          when :chrome
            capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
                :platform=>RSpec.configuration.host_platform,
                :version=>RSpec.configuration.host_version,
                :url=>"http://#{RSpec.configuration.host_ip}:#{RSpec.configuration.host_port}/wd/hub")
          when :safari
            capabilities = Selenium::WebDriver::Remote::Capabilities.safari(
                :platform=>RSpec.configuration.host_platform,
                :version=>RSpec.configuration.host_version,
                :url=>"http://#{RSpec.configuration.host_ip}:#{RSpec.configuration.host_port}/wd/hub")
          when :ie
            capabilities = Selenium::WebDriver::Remote::Capabilities.ie(
                :platform=>RSpec.configuration.host_platform,
                :version=>RSpec.configuration.host_version,
                :url=>"http://#{RSpec.configuration.host_ip}:#{RSpec.configuration.host_port}/wd/hub")
          when :iphone
            capabilities = Selenium::WebDriver::Remote::Capabilities.iphone(
                :platform=>"MAC",
                :platformName=>"iOS", # for appium v1.2
                :version=>RSpec.configuration.host_version,
                :url=>"http://#{RSpec.configuration.host_ip}:#{RSpec.configuration.host_port}/wd/hub",
                :sdkVersion=>RSpec.configuration.host_version,
                :simulator=>true,
                :deviceName=>"iphone",
                :browserName=>"safari")
          when :ipad
            capabilities = Selenium::WebDriver::Remote::Capabilities.ipad(
                :platform=>"MAC",
                :platformName=>"iOS", # for appium v1.2
                :version=>RSpec.configuration.host_version,
                :url=>"http://#{RSpec.configuration.host_ip}", #":#{RSpec.configuration.host_port}/wd/hub",
                :sdkVersion=>RSpec.configuration.host_version,
                :simulator=>true,
                :deviceName=>"ipad",
                :browserName=>"safari")
          else
            capabilities = Selenium::WebDriver::Remote::Capabilities.firefox(
                :platform=>RSpec.configuration.host_platform,
                :version=>RSpec.configuration.host_version,
                :url=>"http://#{RSpec.configuration.host_ip}:#{RSpec.configuration.host_port}/wd/hub")
        end
        driver = Capybara::Selenium::Driver.new(app,
                                       :browser => :remote,
                                       :desired_capabilities => capabilities,
                                       :url=>"http://#{RSpec.configuration.host_ip}:4444/wd/hub",
                                       :http_client=>client)
      end
      driver
    end
  end
end