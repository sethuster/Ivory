
module Pages
  class CheckoutShippingPage < BasePage

    element :continue_btn, :xpath, "//input[@value='Continue >']"
    #Error Text Elements
    element :po_box_Error, :xpath, "//*[contains(text(), 'cannot ship to PO boxes')]"
    section :add_shipping_section, AddShippingSection, '#new_okl_customer_client_v1_shipping_address'

    set_url '/checkout/address'

    def wait_for_elements
      wait_until_continue_btn_visible

      self
    end

    ##
    # Enter the shipping details into the form
    # @param [Hash] shipping_info: A hash containing the shipping address and phone
    # shipping_info = {:first,
    #                  :last,
    #                  :address1,
    #                  :address2, #optional
    #                  :city,
    #                  :state,
    #                  :state_abbr,
    #                  :zip,
    #                  :phone}

    def EnterShippingDetails(shipping_info)
      add_shipping_section.EnterShippingDetails(shipping_info)

      CheckoutShippingPage.new
    end

    def Continue
      continue_btn.click
      CheckoutPaymentPage.new
    end

    def ContinueCheckout
      continue_btn.click
      ReviewOrderPage.new
    end

    def ContinueBadAddress
      continue_btn.click
      wait_for_po_box_Error
      CheckoutShippingPage.new
    end

    def ContinueAddressVerify
      wait_for_continue_btn
      continue_btn.click
      VerifyShippingAddress.new
    end
  end
end
