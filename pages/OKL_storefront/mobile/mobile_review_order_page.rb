module Pages
  class MobileReviewOrderPage < SitePrism::Page
    set_url '/checkout/review'

    element :shipping_name, :xpath, "//div[@class='shipping-info']/a/p[1]"
    element :shipping_address, :xpath, "//div[@class='shipping-info']/a/p[2]"
    element :city_state_zip, :xpath, "//div[@class='shipping-info']/a/p[3]"
    element :change_address_btn, :xpath, "//div[@class='shipping-info']/a"

    element :cc_last_four_lbl, :xpath, "//div[@class='billing-info']/a/p[2]" # <Card> ending in xxxx
    element :cc_expires_lbl, :xpath, "//div[@class='billing-info']/a/p[3]" # Expires xx/xxxx
    element :change_payment_btn, :xpath, "//div[@class='billing-info']/a"
    element :place_order_btn, "button[type=submit]", :text => 'Submit'

    # Gift message related
    element :add_gift_msg, :xpath, "//*[@class='chk-section'][3]/"
    element :gift_msg_textarea, '#gift-message-textarea'
    element :gift_msg_done_btn, "button[type=submit]", :text => 'Save'

    # PayPal PaymentMethod
    element :pay_pal_icon, '.paypal-payment-icon'
    element :pay_pal_email, :xpath, "//div[contains(@class,'billing-info')]/a/p"

    def wait_for_elements
      wait_until_place_order_btn_visible

      self
    end

    def AddGiftMessage(msg)
      wait_until_add_gift_msg_visible
      add_gift_msg.click
      wait_until_gift_msg_textarea_visible
      wait_until_gift_msg_done_btn_visible
      gift_msg_textarea.set msg
      gift_msg_done_btn.click

      # wait for the modal to disappear
      wait_until_gift_msg_textarea_invisible

      # verify the gift message was added to the form
      find_first(:xpath, "//*[contains(text(),'" + msg + "')]")

      MobileReviewOrderPage.new
    end


    def ChangeAddShippingDetails(shipping_info)
      change_address_btn.click
      MobileCheckoutShippingPage.new.EnterShippingDetails(shipping_info)

      MobileReviewOrderPage.new
    end

    def ChangePaymentMethod(billing_info, save_payment_info, use_shipping_address)
      change_payment_btn.click
      MobileCheckoutPaymentPage.new.
          EnterBillingInfo(billing_info, save_payment_info, use_shipping_address).
          Continue

      MobileReviewOrderPage.new
    end

    def VerifyAddressAndCreditCardAdded(shipping_info, billing_info)
      raise "Failed to verify '#{billing_info[:fullname]}' displayed" if not shipping_name.text.eql?(billing_info[:fullname])
      raise "Failed to verify '#{shipping_info[:address1]}' displayed" if not shipping_address.text.eql?(shipping_info[:address1])


      c_s_z_str = "#{shipping_info[:city]}, #{shipping_info[:state_abbr]} #{shipping_info[:zip]}"
      raise "Failed to verify '#{}' displayed" if not city_state_zip.text.eql?(c_s_z_str)
      cc_num = billing_info[:credit_card_num]
      exp_month = billing_info[:exp_month]
      exp_month = "0" + billing_info[:exp_month] if billing_info[:exp_month].length
      exp_year = billing_info[:exp_year]

      cc_lbl_txt = "Visa ending in #{cc_num[-4,4]}"
      exp_lbl_txt = "Expires #{exp_month}/#{exp_year}"

      raise "Failed to verify '#{cc_lbl_txt}' displayed" if not cc_last_four_lbl.text.eql?(cc_lbl_txt)

      self
    end

    def VerifyPayPalPaymentMethod
      wait_until_pay_pal_icon_visible
      wait_until_pay_pal_email_visible

      if has_no_pay_pal_email? :text => PayPalPage.email
        raise "Failed to verify PayPal email address should be #{PayPalPage.email}"
      end

      self
    end

    def PlaceOrder
      wait_until_place_order_btn_visible
      place_order_btn.click

      MobileOrderCompletedPage.new
    end

  end
end