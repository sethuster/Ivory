module Sections
  class AddPaymentSection < BaseSection
    element :pay_with_credit_card, '.new-credit-card'
    element :card_name_field, '#cardholder-name-input'
    element :card_number_field, '#okl_customer_client_v1_payment_card_card_number'
    element :card_exp_month_dropdown, '#expire-month'
    element :card_exp_year_dropdown, '#expire-year'
    element :card_cvc_field, '#security-code'

    element :first_name_field, '.js-firstname'
    element :last_name_field, '.js-lastname'
    element :address1_field, '.js-address1'
    element :address2_field, '.js-address2' # optional
    element :city_field, '.js-city'
    element :zip_field, '.js-postcode'
    element :state_dropdown, '#okl_customer_client_v1_payment_card_billing_address_attributes_state'
    element :phone_field, '.js-phone'

    ##
    # Enter payment details into the form
    #
    # @param [Hash] billing_info: The billing info hash
    # billing_info = {:fullname,
    #                :credit_card_num,
    #                :exp_month,
    #                :exp_year,
    #                :cvc}
    def EnterPaymentInfo(billing_info)
      self.card_name_field.set billing_info[:fullname]
      self.card_number_field.set billing_info[:credit_card_num]
      self.card_exp_month_dropdown.select billing_info[:exp_month]
      self.card_exp_year_dropdown.select billing_info[:exp_year]
      self.card_cvc_field.set billing_info[:cvc]
    end


    ##
    # Enter the billing address and phone into the form
    # @param [Hash] address: A hash containing the address information
    # address = {:first,
    #            :last,
    #            :address1,
    #            :address2, #optional
    #            :city,
    #            :state,
    #            :zip,
    #            :phone}
    def EnterPaymentAddressAndPhone(address)
      self.first_name_field.set address[:first]
      self.last_name_field.set address[:last]
      self.address1_field.set address[:address1]
      self.address2_field.set address[:address2] if address[:address2]
      self.city_field.set address[:city]
      self.state_dropdown.select address[:state]
      self.zip_field.set address[:zip]
      self.phone_field.set address[:phone]
    end

  end
end