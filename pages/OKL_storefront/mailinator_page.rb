module Pages
  class MailinatorPage <BasePage
    include Capybara::DSL
    set_url "http://mailinator.com/inbox.jsp?to={username}"
    element :inbox_control_panel,'#InboxCtrl'

    def ClickMailWithText text
      using_wait_time 30 do
        find_first(:xpath, "//div[contains(text(),'" + text + "')]").click
      end
    self
    end

    def ClickBodyText text
      find_first(:xpath, "//*[contains(text(),'" + text + "')]").click
      self
    end
    def ClickXpath xpath
      find_first(:xpath, xpath).click
    end
  end
end
