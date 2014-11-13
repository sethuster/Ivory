require 'capybara/node/element'
require 'selenium-webdriver'

module Capybara
  module Node
    class Element
      include Capybara::DSL
      attr_reader :query

      def present?
         page.has_selector? @query.selector.format, @query.locator
      end

      def set_checked(value)
        if (self.checked? and not value) or (not self.checked? and value)
          self.click
        end
      end

      def get_selected_option
        by = nil

        if @query.locator.include?("//")
          by = :xpath
        else
          by = :css
        end

        page.driver.browser.find_element(by => @query.locator).find_element(:css, "option[selected]").text
      end

      def select_dropdown_option(option)
        by = nil

        if @query.locator.include?("//")
          by = :xpath
        else
          by = :css
        end

        _select = page.driver.browser.find_element(by => @query.locator)
        _select.click
        _select.find_element(:xpath, "./option[text()='#{option}']").click
      end

      def drag_to(target_element)
        dnd_javascript = File.read(File.join(Dir.pwd, 'core/html5_drag_n_drop.js'))
        page.driver.browser.execute_script(dnd_javascript+"$('#{@query.locator}').simulateDragDrop({ dropTarget: '#{target_element.query.locator}'});")
      end
    end
  end
end
