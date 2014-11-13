
module Pages
  class MobileCheckoutPaymentPage<BasePage
    set_url "/checkout/payment"

    # paypal only
    element :pay_with_paypal_button, 'label.paypal-toggle'
    element :pay_with_credit_card_button, 'label[for=new-credit-card]'


    section :payment_info, AddPaymentSection, '#new_okl_customer_client_v1_payment_card'
    element :use_shipping_address, '#use-shipping-address'

    element :next_button, "button[type=submit]", :text => 'Next'

# the following are if you are NOT using paypal
    element :card_name_field, '#okl_customer_client_v1_payment_card_cardholder_name'
    element :card_number_field, '#okl_customer_client_v1_payment_card_card_number'
    element :card_exp_month_dropdown, '#okl_customer_client_v1_payment_card_expiration_month'
    element :card_exp_year_dropdown, '#okl_customer_client_v1_payment_card_expiration_year'
    element :card_cvc_field, '#okl_customer_client_v1_payment_card_security_code'

    element :first_name_field, '#okl_customer_client_v1_payment_card_billing_address_attributes_firstname'
    element :last_name_field, '#okl_customer_client_v1_payment_card_billing_address_attributes_lastname'
    element :address1_field, '#okl_customer_client_v1_payment_card_billing_address_attributes_address_1'
    element :address2_field, '#okl_customer_client_v1_payment_card_billing_address_attributes_address_2' # optional
    element :city_field, '#okl_customer_client_v1_payment_card_billing_address_attributes_city'
    element :zip_field, '#okl_customer_client_v1_payment_card_billing_address_attributes_postcode'
    element :state_dropdown, '#okl_customer_client_v1_payment_card_billing_address_attributes_state'
    element :phone_field, '#okl_customer_client_v1_payment_card_billing_address_attributes_phone'

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

      self
    end


    def wait_for_elements
      wait_until_continue_btn_visible

      self
    end

    def PayWithPaypal
      pay_with_paypal_button.click
      continue_btn.click

      PayPalPage.new
    end

    ##
    # Enter billing details into the form
    #
    # @param [Hash] billing_info: The billing info hash
    # billing_info = {:fullname,
    #                :credit_card_num,
    #                :exp_month,
    #                :exp_year,
    #                :cvc}
    # @param [Boolean] use_shipping_address: To set the billing address as the shipping address
    def EnterBillingInfo(billing_info)
      payment_info.EnterPaymentInfo(billing_info, use_shipping_address)

      self.use_shipping_address.set_checked(use_shipping_address)

      MobileCheckoutPaymentPage.new
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
    def EnterBillingAddressAndPhone(address)
      payment_info.EnterPaymentAddressAndPhone(address)
      MobileCheckoutPaymentPage.new
    end

    def Next
      next_button.click

      MobileReviewOrderPage.new
    end
  end
end