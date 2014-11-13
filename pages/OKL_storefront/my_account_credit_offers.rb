module Pages
  class MyAccountCreditOffersPage < BasePage

    section :header, LoggedInHeader, '.okl-header'

    element :credits_info_label, :xpath, "//*[contains(text(), 'Available Credits')]"
    element :credits_amount_label, :xpath, "//*[contains(text(), '$15.00')]"

    def wait_for_elements
      wait_until_credits_info_label_visible
      wait_until_credits_amount_label_visible

      self
    end
  end
end