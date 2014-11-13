##
# NOTE: This framework only supports manipulating, verifying, one item in the cart at a time.
#       Possible inadequacy with the site_prism gem and 'sections'
##
module Pages

  class CartRowSection < SitePrism::Section
    element :image_link, '#image-link'
    element :name_link, :xpath, "//a[contains(@href,'product') and not(contains(@class, 'image-link'))]"
    element :delivery_notice, '.virtual-delivery-notice'
    element :return_policy_notice, '.return-policy-notice'
    element :unit_price_label, '.unit-price'
    element :item_quantity_dropdown, 'select[name=quantity]'
    element :total_price_label, '.total-price'
    element :remove_item_link, '.remove-link'

    def to_s
      $logger.Log("\nCartRow name: #{name_link.text} \nDeliveryNotice: #{delivery_notice.text} \nTotalPriceLabel: #{total_price_label.text}\n")
    end
  end

  class ShoppingCartPage < BasePage
    set_url '/cart'

    section :header, LoggedInHeader, '.okl-header'

    element :check_out_now_top_button, :xpath, '//header//a[contains(@class,"checkout-btn")]'
    element :item_reservation_duration, '.countdown'
    element :add_offer_code_link, '.addOfferCode'
    element :continue_shopping_link, '#continue-shopping-btn'
    element :exclusions_link, '#ship-promo-exclusions'
    element :subtotal_label, :xpath, 'ul[class=credit-warnings]/d1/dd[1]'
    element :shipping_label, '#shipping'
    element :estimated_tax_label, 'dd[class=totals]'
    elements :order_totals, 'dd'
    element :check_out_now_button, :xpath, '//div[@class="checkout-nav"]/a'
    element :paypal_button, 'img[alt=Btn_xpresscheckout]'
    element :cart_timed_out_message, '.expired-msg'

    elements :remove_links, ".remove-link"
    element :visit_all_sales, ".okl-btn"

    sections :cart_items, CartRowSection, :xpath, ".//ul[@class='cart-lines']/li[@class='clearfix']"

    # Invite Referral Credit
    element :referral_credit_label, :xpath, "//*[contains(text(), 'Referral Credit')]"
    element :referral_credit_deduction_label, :xpath, "//*[contains(text(), '-$15.00')]"


    def CheckOutNow(is_shipping_info_saved=false, is_credit_card_saved=false)
      check_out_now_button.click

      # if the credit card is already saved in the system,
      # then the Review Order Page is displayed, otherwise the CheckoutShipping Page is displayed.
      if is_shipping_info_saved and is_credit_card_saved
        return ReviewOrderPage.new
      elsif is_shipping_info_saved and not is_credit_card_saved
        return CheckoutPaymentPage.new
      else
        return CheckoutShippingPage.new
      end
    end

    def CheckOutAgain()
      check_out_now_button.click
      return ReviewOrderPage.new
    end

    def VerifyCartEmpty
      #Sometimes when running the remove all items function the remove link doesn't get clicked

      if self.has_no_remove_links? #this will check to see if the page has remove links before verifying cart is empty
        empty_cart = 'Your cart is empty'
        wait_for_visit_all_sales
        find_first(:xpath, "//*[contains(text(),'" + empty_cart + "')]")
        cart_items.size.should == 0
      else
        self.RemoveAllItemsFromCart
      end
      self
    end

    def RemoveAllItemsFromCart
      num_items = remove_links.size

      num_items.times do
        remove_links.first.click
        ShoppingCartPage.new
      end

      self.VerifyCartEmpty
    end

    ### items is an array of product text ###
    def VerifyItemsInCart(items)
      items.each {|item| find_first(:xpath, "//*[contains(text(),'" + item + "')]")}
    end

    def RemoveItemFromCart(item_to_remove)

      cart_items.each do |item|
        if item.name_link.text.eql?(item_to_remove)
          item.remove_item_link.click
          break
        end
      end

      ShoppingCartPage.new
    end

    def VerifyItemRemovedFromCart(product_name)
      if(cart_items.size > 0)
        cart_items.each do |item|
          if item.name_link.text.eql?(product_name)
            raise "#{product_name} was not removed from shopping cart"
          end
        end
      else
        self.VerifyCartEmpty
      end

      self
    end

    def ChangeVerifyItemQuantityUpdated(qty)
      # Updating the quantity
      cart_items.first.item_quantity_dropdown.select(qty) if qty > 0

      # Go back to the HomePage and enter the shopping cart again, to verify product qty was updated
      @page = HomePage.new
      @page.load
      @page.header.GoToCart

      if cart_items.first.item_quantity_dropdown.get_selected_option.eql?(qty.to_s)
        $logger.Log("Successfully verified the quantity of the item was updated to #{qty}")
      else
        raise "Failed to verify the quantity of the item in the shopping cart was updated to #{qty}"
      end
    end

    def CheckoutWithPayPal
      paypal_button.click

      PayPalPage.new
    end

    def VerifyReferralCreditApplied
      wait_until_referral_credit_label_visible
      wait_until_referral_credit_deduction_label_visible

      self
    end

    def PricingInformation
      #this is used primarily in the TaxRate_spec
      priceItems = Array.new
      wait_for_order_totals
      for total in order_totals
        priceItems.push(total.text.delete('$'))
      end
      return priceItems
    end
  end



end
