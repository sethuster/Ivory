module Sections
  class MobileCartItem<BaseSection
    element :item_logo, 'figure.prd-image'
    element :item_title_label, 'p.prd-title'
    element :item_cost_label, 'p.prd-okl-price'
    element :delivery_label, 'li.virtual-delivery-notice'
    element :quantity_dropdown, 'select[name=quantity]'
    element :remove_button, 'section.product.cart-product a',:text=>"Remove"
  end
end


module Pages
  class MobileCartPage<BasePage
    set_url '/cart'

    element :back_button, :xpath, "//*[@class='command chk-command cart-command back-command']/a"
    element :cart_timer_label, 'abbr.timer'
    element :check_out_button, 'a', :text => 'Checkout'
    element :pay_with_creditcard_button, 'a.tgl-choice',:text=>'Credit Card'
    element :pay_with_paypal_button, 'a.tgl-choice',:text=>'PayPal'

    element :subtotal_label, :xpath, '//tr[./td[text()="Subtotal"}]/td[@class="cost-item"]'
    element :shipping_label, :xpath, '//tr[./td[text()="Shipping"}]/td[@class="cost-item"]'
    element :estimated_tax_label, :xpath, '//tr[./td[text()="Estimated Tax"}]/td[@class="cost-item"]'
    element :order_total_label, :xpath, '//tr[@class="total"]/td[@class="cost-item"]'
    element :apply_gift_card_button, 'div.offer-code'

    element :item_reservation_duration, 'abbr.timer'

    sections :cart_items, MobileCartItem, :xpath, "//section[contains(@class,'cart-lines') and not (contains(@class, 'expired-chk-section'))]/ul/li"

    elements :remove_btns, 'a.cl-remove-command'



    def CheckOutNow(is_shipping_info_saved=false, is_credit_card_saved=false)
      #wait_until_check_out_button_visible
      wait_until_order_total_label_visible

      check_out_button.click

      # if the credit card is already saved in the system,
      # then the Review Order Page is displayed, otherwise the CheckoutShipping Page is displayed.
      if is_shipping_info_saved and is_credit_card_saved
        return MobileReviewOrderPage.new
      elsif is_shipping_info_saved and not is_credit_card_saved
        return MobileCheckoutPaymentPage.new
      else
        return MobileCheckoutShippingPage.new
      end
    end

    def BackHome
      #Should only be used if coming from the home page
      wait_for_back_button
      back_button.click
      MobileHomePage.new
    end

    def VerifyCartEmpty
      empty_cart = 'Your Cart is Empty'
      find_first(:xpath, "//*[contains(text(),'" + empty_cart + "')]")
      cart_items.size.should == 0

      self
    end

    def RemoveAllItemsFromCart
      numItems = remove_btns.size

      numItems.times do
        remove_btns.last.click
        MobileCartPage.new
      end

      self.VerifyCartEmpty
    end

    ### items is an array of product text ###
    def VerifyItemsInCart(items)
      items.each {|item| find_first(:xpath, "//*[contains(text(),'" + item + "')]")}

      self
    end

    def RemoveItemFromCart(item_to_remove)
      cart_items.each do |item|
        if item.item_title_label.text.eql?(item_to_remove)
          item.remove_button.click
          wait_until_cart_items_invisible
          break
        end
      end

      MobileCartPage.new
    end

    def VerifyItemRemovedFromCart(product_name)
      if(cart_items.size > 0)
        cart_items.each do |item|
          if item.item_title_label.text.eql?(product_name)
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
      cart_items.first.quantity_dropdown.select(qty) if qty > 0

      # Go back to the HomePage and enter the shopping cart again, to verify product qty was updated
      @page = MobileHomePage.new
      @page.load
      @page.header.GoToCart
      selectedQty = cart_items.first.quantity_dropdown.text.to_i


      if selectedQty.equal?(qty)
        $logger.Log("Successfully verified the quantity of the item was updated to #{qty}")
      else
        raise "Failed to verify the quantity of the item in the shopping cart was updated to #{qty}"
      end
    end

    def PayWithPaypal
      pay_with_paypal_button.click

      PayPalPage.new
    end
  end
end