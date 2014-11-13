module Sections
  class AddShippingSection < BaseSection
    element :first_name_field, '#firstname'
    element :last_name_field, '#lastname'
    element :address_field, '#address1'
    element :address_line2_field, '#address2'
    element :city_field, '#city'
    element :state_dropdown, '#zone'
    element :zipcode_field, '#postcode'
    element :phone_number_field, '#phonenumber'

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
      if all_there?
        first_name_field.set shipping_info[:first]
        last_name_field.set shipping_info[:last]
        address_field.set shipping_info[:address1]
        address_line2_field.set shipping_info[:address2] if shipping_info[:address2]
        city_field.set shipping_info[:city]
        state_dropdown.select shipping_info[:state]
        zipcode_field.set shipping_info[:zip]
        phone_number_field.set shipping_info[:phone]
      end
    end
  end
end