module Pages
  # Review Order Page
  # ModifiedBy: Seth Urban
  # Date: 07/08/14
  # Purpose: This page object represents the shopping cart page after shipping and payment
  # information has been supplied by the customer.


  class ReviewOrderPage < SitePrism::Page
    set_url '/checkout/review'

    element :shipping_name, :xpath, "//div[@id='shippingAddressContent']/ul/li[@class='selected']/p[1]"
    element :shipping_address, :xpath, "//div[@id='shippingAddressContent']/ul/li[@class='selected']/p[2]"
    element :city_state_zip, :xpath, "//div[@id='shippingAddressContent']/ul/li[@class='selected']/p[3]"
    element :phone, :xpath, "//div[@id='shippingAddressContent']/ul/li[@class='selected']/p[4]"
    element :change_address_btn, :xpath, "//ul[@id='shippingAddressMenu']/li/button"
    element :add_address_btn, '.addAddressLink'

    element :cc_last_four_lbl, :xpath, "//div[contains(@class,'billingInfo')]/p" # <Card> ending in xxxx
    element :cc_expires_lbl, :xpath, "//div[contains(@class,'billingInfo')]" # Expires xx/xxxx
    element :change_payment_btn, :xpath, "//a[text()='Change']"
    element :place_order_btn, :xpath, "//*[contains(text(),'Place your order')]"

    # Gift message related
    element :add_gift_msg, '#editMessage'
    element :gift_msg_textarea, '#giftMessageText'
    element :gift_msg_done_btn, '#submitGiftMessage'

    # PayPal PaymentMethod
    element :pay_pal_icon, '.paypalIcon'
    element :pay_pal_email, :xpath, "//div[contains(@class,'billingInfo')]/p"

    #totals container
    element :prod_total, '.total-price'  #this is the total for the product
    #this is an array of all the totals. Order: sub-total, shipping, estimated tax, and order total
    elements :totals , '.totals-container dl dd'


    def wait_for_elements
      wait_until_place_order_btn_visible

      self
    end

    def VerifyTotals
      #TODO: test this function
      #Verifies the totals are calculated correctly
      wait_for_totals
      totals.size.should >= 4 #sub-total, shipping, tax and total
      prodTotal = prod_total.text.strip('$').to_f
      subTotal = totals.first.text.strip('$').to_f

      #first check to make sure the product total matches the sub-total
      if prodTotal != subTotal
        raise "SubTotal does not match Product Price"
      end

      #go through all the values in the totals container and verify the total is correct
      for i in totals.size
        calctotal += totals[i].text.strip('$').to_f
        if i.equal?(totals.size)
          calctotal -= totals[i].text.strip('$').to_f
        end
      end

      if calctotal != totals.last.text.strip('$').to_f
        raise "Order Total: " + totals.last.text + "does not match calculated total: " + calctotal.to_s
      end

      self
    end

    def AddGiftMessage(msg)
      add_gift_msg.click
      wait_until_gift_msg_textarea_visible
      wait_until_gift_msg_done_btn_visible
      gift_msg_textarea.set msg
      gift_msg_done_btn.click

      # wait for the modal to disappear
      wait_until_gift_msg_textarea_invisible

      # verify the gift message was added to the form
      find_first(:xpath, "//*[contains(text(),'" + msg + "')]")

      ReviewOrderPage.new
    end


    def ChangeAddShippingDetails(shipping_info)
      change_address_btn.click
      add_address_btn.click
      CheckoutShippingPage.new.EnterShippingDetails(shipping_info).ContinueCheckout

      ReviewOrderPage.new
    end

    def ChangePaymentMethod(billing_info, save_payment_info, use_shipping_address)

      change_payment_btn.click
      CheckoutPaymentPage.new.ChooseNewCC.
          EnterBillingInfo(billing_info, save_payment_info, use_shipping_address).
          Continue

      ReviewOrderPage.new
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

      OrderCompletedPage.new
    end

  end
end