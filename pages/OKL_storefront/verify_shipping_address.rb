
module Pages
  class VerifyShippingAddress < BasePage
    #TODO - Make this a section instead of a page
    elements :address_list, '#address-suggestions-list li input'
    element :continue_btn, :xpath, "//input[@value='Continue >']"

    def SelectEnteredAddress
      wait_for_address_list
      address_list.last.click
      wait_for_continue_btn
      continue_btn.click

      CheckoutPaymentPage.new
    end



  end #endClass
end #endModule