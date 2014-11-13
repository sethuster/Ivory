module Pages
  class MobileCheckoutShippingPage<BasePage
    element :first_name_field, '#firstName'
    element :last_name_field, '#lastName'
    element :address_field, '#address1'
    element :address_line2_field, '#address2'
    element :city_field, '#city'
    element :state_dropdown, '#okl_customer_client_v1_shipping_address_state'
    element :zipcode_field, '#postalCode'
    element :phone_number_field, '#phoneNumber'

    element :back_button, 'a', :text => "Back"
    element :next_button, 'button[name=submitShippingAddress]'
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
      # if none of these elements are present, the address information has most likely already been
      # entered into the system and saved
      sleep 10

      if all_there?
        first_name_field.set shipping_info[:first]
        last_name_field.set shipping_info[:last]
        address_field.set shipping_info[:address1]
        address_line2_field.set shipping_info[:address2] if shipping_info[:address2]
        city_field.set shipping_info[:city]
        state_dropdown.select shipping_info[:state]
        zipcode_field.set shipping_info[:zip]
        phone_number_field.set shipping_info[:phone]
      else
        $logger.Log("#{__method__}(): Failed to find the mobile shipping page. Possible shipping info already entered")
      end

      self
    end

    def Next
      next_button.click if has_next_button?
      MobileCheckoutPaymentPage.new
    end

  end
end