module Pages
  class MyAccountInformationPage < BasePage
    attr_reader :account_tabs

    set_url '/my_account'

    section :account_tabs, MyAccountTabsSection, '.account-tabs'
    section :header, LoggedInHeader, '.okl-header'
    section :footer, LoggedInFooter, '#footer'

    # Only supports the ability to verify one credit card and one shipping address
    element :shipping_name, :xpath, "//li[@class='account-item js-primary']/p[1]"
    element :shipping_address, :xpath, "//li[@class='account-item js-primary']/p[2]"
    element :shipping_address2, :xpath, "//li[@class='account-item js-primary']/p[3]"
    element :city_state_zip, :xpath, "//li[@class='account-item js-primary']/p[4]"

    element :add_payment_btn, :xpath, "//ul[contains(@class, 'payment-list')]/li/a"
    element :add_shipping_btn, :xpath, "//ul[contains(@class, 'address-list')]/li/a"


    def AddPaymentMethod
      add_payment_btn.click

      AddPaymentPage.new
    end

    def AddShippingAddress
      add_shipping_btn.click

      AddShippingPage.new
    end

    ##
    # Remove the payment method from the account
    #
    # @param [Hash] billing_info: The billing info hash
    # billing_info = {:fullname,
    #                :credit_card_num,
    #                :exp_month,
    #                :exp_year,
    #                :cvc}
    def RemovePaymentMethod(billing_info)
      xpath_str = "//input[contains(@value, 'Delete') and ../../../../*[contains(text(),'" + billing_info[:credit_card_num][-4,4] + "')]]"
      find_first(:xpath, xpath_str).click

      MyAccountInformationPage.new
    end

    ##
    # Verify billing details were added to the page
    #
    # @param [Hash] billing_info: The billing info hash
    # billing_info = {:fullname,
    #                :credit_card_num,
    #                :exp_month,
    #                :exp_year,
    #                :cvc}
    def VerifyPaymentAdded(billing_info)
      last_4_str = "Last 4 digits: #{billing_info[:credit_card_num][-4,4]}"
      expires_str = "Expires: #{billing_info[:exp_month]}/#{billing_info[:exp_year]}"

      find_first(:xpath, "//*[contains(text(),'" + last_4_str + "')]")
      find_first(:xpath, "//*[contains(text(),'" + expires_str + "')]")
    end

    ##
    # Verify billing details were removed from the page
    #
    # @param [Hash] billing_info: The billing info hash
    # billing_info = {:fullname,
    #                :credit_card_num,
    #                :exp_month,
    #                :exp_year,
    #                :cvc}
    def VerifyPaymentMethodRemoved(billing_info)
      delete_payment_xpath = "//input[contains(@value, 'Delete') and ../../../../*[contains(text(),'" + billing_info[:credit_card_num][-4,4] + "')]]"

      if element_exists?(:xpath, delete_payment_xpath)
        raise "Failed to verify the payment method with last 4 digits '#{billing_info[:credit_card_num][-4,4]}' was removed"
      end

      MyAccountInformationPage.new
    end

    ##
    # Verify shipping details were added to the page
    #
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
    def VerifyShippingInfoAdded(shipping_info)

      shipping_name = "#{shipping_info[:first]} #{shipping_info[:last]}"
      if has_no_shipping_name? :text => shipping_name
        raise "Failed to verify shipping name should be '#{shipping_name}'"
      end

      if has_no_shipping_address? :text => shipping_info[:address1]
        raise "Failed to verify shipping address should be '#{shipping_info[:address1]}'"
      end

      # optional
      if shipping_info[:address2]
        if has_no_shipping_address2? :text => shipping_info[:address2]
          raise "Failed to verify shipping address2 should be '#{shipping_info[:address2]}'"
        end
      end

      c_s_z = "#{shipping_info[:city]}, #{shipping_info[:state_abbr]}, #{shipping_info[:zip]}"
      if has_no_city_state_zip? :text => c_s_z
        raise "Failed to verify shipping city, state, zip should be '#{c_s_z}'"
      end

    end

    ##
    # Remove the shipping info from the account
    #
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
    def RemoveShippingInfo(shipping_info)
      xpath_str = "//input[contains(@value, 'Delete') and ../../../../*[contains(text(),'" + shipping_info[:address1] + "')]]"
      find_first(:xpath, xpath_str).click

      MyAccountInformationPage.new
    end

    ##
    # Verify shipping info was removed from the page
    #
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
    def VerifyShippingInfoRemoved(shipping_info)
      delete_shipping_xpath = "//input[contains(@value, 'Delete') and ../../../../*[contains(text(),'" + shipping_info[:address1] + "')]]"

      if element_exists?(:xpath, delete_shipping_xpath)
        raise "Failed to verify the shipping address '#{shipping_info}' was removed"
      end

      MyAccountInformationPage.new
    end

  end
end