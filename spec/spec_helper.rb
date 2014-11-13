$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'core'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'tests'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rspec'
require 'capybara'
require 'capybara/rspec'
require 'rspec/core'
require 'capybara/rspec/matchers'
require 'capybara/rspec/features'
require 'site_prism'
require 'selenium-webdriver'
require 'browsers'
require "command_logger"
require 'j_unit_reporter'
require 'config'
require "capybara-screenshot"
require 'capybara-screenshot/rspec'
require 'capybara_extensions'
require 'ruby_extensions'
require "aquarium"
require "syntax"
require 'browsermob/proxy'
require 'require_all'
require 'base_page'
require 'base_section'

include Browsers

# Helper constants for switching in/out code for iphone or IOS
IPHONE = RSpec.configuration.default_browser.eql?(Browsers::IPhone)
IOS = RSpec.configuration.default_browser.eql?(Browsers::IPhone) || RSpec.configuration.default_browser.eql?(Browsers::IPad)

Capybara.default_driver = :selenium
Capybara.app_host = RSpec.configuration.default_url
Capybara.default_wait_time = RSpec.configuration.element_wait_sec
Capybara.run_server = false

Capybara::Screenshot.append_timestamp = false
Capybara::Screenshot.register_filename_prefix_formatter(:rspec) do |example|
  "screenshot_" + RSpec.configuration.test_name
end
setup_browser



















