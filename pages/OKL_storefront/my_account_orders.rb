module Pages
  class MyAccountOrdersPage < BasePage
    set_url '/orders'

    def wait_for_elements
      find_first(:xpath, "//*[contains(text(),'Order Status')]")
      self
    end
  end
end