require 'aquarium'
require 'config'
  class LogStatement
    attr_accessor :text, :color
    def initialize (text, color='Black')
      @text = text;
      @color = color
    end
  end

  class CommandLogger
    attr_accessor :log

    def initialize
      @log = Array.new
    end

    def Log(text, color='Black')
      timestamp = "#{(DateTime.now.strftime("%-m-%d-%Y-%H:%M:%S"))}"
      if(color=='Red')
        text = "ERROR : " + text
      end
      text = "[#{timestamp}] #{text}"
      puts text
      @log << LogStatement.new(text,color)
    end

    def Print
      puts {|x| puts x.text }
    end
  end

$logger = CommandLogger.new

include Aquarium::Aspects
  Aspect.new :after, :calls_to => :all_methods,:exclude_calls_to => [/^visible/,/^allow_reload/,/^text/],:for_types => [Capybara::Node::Element,Capybara::Node::Actions],:method_options => :exclude_ancestor_methods do |jp, obj, *args|
    begin
      names = "#{jp.method_name}"
      $logger.Log "#{names} #{args}"
    ensure

    end
  end

methods_to_exclude = ["all"] if RSpec.configuration.less_verbose_logging
  Aspect.new :after, :calls_to => :all_methods,:in_type => Capybara::Node::Finders,:method_options => :exclude_ancestor_methods, :exclude_methods => methods_to_exclude do |jp, obj, *args|
    begin
      names = "#{jp.method_name}"
      $logger.Log "#{names} #{args}"
    ensure

    end
  end

  Aspect.new :after, :calls_to => [/^visit/],:in_type => Capybara::Session,:method_options => :exclude_ancestor_methods do |jp, obj, *args|
    begin
      names = "#{jp.method_name}"
      $logger.Log "#{names} #{args}"
    ensure

    end
  end

    Aspect.new :after_raising, :calls_to => :all_methods,:in_type => Capybara::Node::Finders,:method_options => :exclude_ancestor_methods do |jp, obj, *args|
      begin
        names = "#{jp.method_name}"
        $logger.Log "Element Not Found : #{args}", 'Red'
      ensure

      end
    end
