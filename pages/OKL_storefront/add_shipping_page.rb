module Pages
  class AddShippingPage < BasePage
    element :save_btn, :xpath, "//input[contains(@value, 'Save')]"
    element :cancel_btn, '.cancel-btn'
    #Error Text Elements
    element :po_box_Error, :xpath, "//*[contains(text(), 'cannot ship to PO boxes')]"
    section :add_shipping_section, AddShippingSection, '#new_okl_customer_client_v1_shipping_address'
    #verify Address sub-page
    element :verify_address, :xpath, "//*[contains(text(), 'Verify Shipping Address')]"
    elements :address_list, '#address-suggestions-list li input'
    element :continue_btn, :xpath, "//input[@value='Continue']"

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

      AddShippingPage.new
    end

    def SaveShippingInfo
      save_btn.click
      if self.has_verify_address?
        wait_for_address_list
        address_list.last.click
        wait_for_continue_btn
        continue_btn.click
      end

      MyAccountInformationPage.new
    end

    def SaveBadShippingInfo
      save_btn.click
      wait_for_po_box_Error
      AddShippingPage.new
    end

    def Cancel
      cancel_btn.click

      MyAccountInformationPage.new
    end
  end
end