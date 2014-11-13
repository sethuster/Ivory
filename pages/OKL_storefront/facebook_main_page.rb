module Pages
  class FacebookMainPage < BasePage
    set_url "http://www.facebook.com"

    element :news_feed_link, :xpath, "//div/span[text()='News Feed']"
    element :user_navigation_dropdown, '#userNavigationLabel'
    element :logout_link, '.uiLinkButtonInput'
    element :loginbutton, '#loginbutton'

    def VerifyProductShared(product_str, shareMessage = nil)

      if ENV['OKL_SERVER'] == OKL_PROD_ENV
        xpath_str = "//a[contains(text(),'%s')]" % product_str
        find(:xpath, xpath_str)
      elsif not shareMessage.nil?
        message_xpath = "//*[contains(text(),'%s')]" % shareMessage
        find(:xpath, message_xpath)
      end

      self
    end

    def GoToNewsFeed
      news_feed_link.click

      self
    end

    def LogOut

      user_navigation_dropdown.click
      logout_link.click
      wait_for_loginbutton
    end
  end
end