module Pages
  class MobileFacebookMainPage < BasePage

    element :news_feed_link, :xpath, "//div[contains(text(),'News Feed')]"

    def VerifyProductShared(product_str)
      xpath_str = "//a[contains(text(),'%s')]" % product_str
      find(:xpath, xpath_str)

      self
    end

    def GoToNewsFeed
      news_feed_link.click

      self
    end
  end
end