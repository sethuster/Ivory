

module Pages
  class AddPaymentPage < BasePage
    section :payment_info, AddPaymentSection, '#new_okl_customer_client_v1_payment_card'
    element :save_btn, :xpath, "//input[contains(@value, 'Save')]"
    element :cancel_btn, '.cancel-btn'

    def Cancel
      cancel_btn.click

      MyAccountInformationPage.new
    end

    def SavePaymentInfo
      save_btn.click

      MyAccountInformationPage.new
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
    def EnterBillingInfo(billing_info)
      payment_info.EnterPaymentInfo(billing_info)

      self
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

      self
    end
  end
end