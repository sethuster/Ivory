=begin
  CreatedBy: Seth Urban
  Purpose: This is the second product detail page or the redesigned one.  Some users get this version
of the page while others get the older version of the page.

Calling classes:  pages/PageSplitters/pdp_splitter.rb

=end

module Sections
  class WhiteGloveToolTip < BaseSection
    element :close_btn, '.close'
    element :title, '.title', :text => 'White glove & home delivery shipping rate'
  end

  class WhiteGloveSection < BaseSection
    element :main_label, :xpath, ".//dt[2]"
    element :description, :xpath, ".//dd[2]"
    element :tool_tip_link, :xpath, ".//dd[2]/a[contains(@class, 'shippingTooltip')]"
  end
end

#TODO WhiteGlove Sections may need to be included
#TODO Any test using the PDP B page will not have an email link

module Pages
  class ProductPage_B<BasePage

    include Sections
    section :header, Sections::LoggedInHeader, '.okl-header'
    element :product_image, '.main-image-section img'
    element :add_to_cart_button, '.add-to-cart'
    element :product_name, '.pdp-prd-overview h1'
    #Pricing
    element :product_price, :xpath, "//*[@class='not-clearance']/p"
    element :msrp_price, :xpath, "//*[@class='not-clearance']/p[2]/span"
    element :percentOff_price, :xpath, "//*[@class='not-clearance']/p[2]/span[2]"
    #size and qty
    element :product_qty_select, '.qty-select'
    elements :qty_options, '.qty-select option'
    element :product_size_select, '.size-select'
    elements :size_options, '.size-select option'
    #social sharing
    element :facebook_share_link, '.facebook-icon a'
    elements :facebook_tool_tip, '.facebook-tooltip div' #like is first, share is last
    element :pinterest_share_link, '.pinterest'
    element :email_share_link, "a.em-share"

    # white glove: not always displayed. Depends on whether or not the product has 'extra'
    # special shipping requirements
    section :white_glove_section, WhiteGloveSection, :xpath, "//dl[contains(@class,'shippingDetails')]"

    # present, but not visible until tool_tip_link is clicked
    section :tool_tip_modal, WhiteGloveToolTip, "#productShipping"

    def ShareViaFacebook(facebook_email, facebook_password, msg=nil)
      product_name_str = product_name.text

      wait_for_facebook_share_link
      facebook_share_link.click
      wait_for_facebook_tool_tip
      facebook_tool_tip.last.click
      sleep 5

      page.within_window( ->{page.title == 'Facebook'} ) do
        FacebookLoginPage.new.LoginToShare(facebook_email, facebook_password).
            VerifyProductNameDisplayed(product_name_str).ShareWith("Friends").ShareLink(msg)
      end

      product_name_str
    end

    def CheckQTY
      updateQTY(self.current_url, 4)
      return self
    end

    # share via email modal
    element :share_email_address_field, '#shareEmailAddress'
    element :share_email_message_text_area, '#share-emailMessage'
    element :share_email_cancel_link, '.cancel'
    element :share_email_send_btn, '.submitShareEmail'

    element :share_email_confirm_label, :xpath, "//div[contains(@id, 'emailSuccess')]//p[contains(text(),'Thanks for sharing')]"
    element :share_email_confirm_close, "div#emailSuccess button"

    def ShareViaEmail(email, message)
      product_name_str = product_name.text

      email_share_link.click

      wait_until_share_email_address_field_visible
      wait_until_share_email_message_text_area_visible

      share_email_address_field.set email if email
      share_email_message_text_area.set message if message
      share_email_send_btn.click

      wait_until_share_email_confirm_label_visible
      wait_until_share_email_confirm_close_visible

      share_email_confirm_close.click

      product_name_str
    end

    def ShareViaPinterest(facebook_email, facebook_password)
      product_name_str = product_name.text
      pinterest_share_link.click
      sleep 1

      new_window = page.driver.browser.window_handles.last

      page.within_window new_window do
        PinterestPage.new.LoginToShare(facebook_email, facebook_password).PinIt
      end

      product_name_str
    end

    def AddToCart(qty=nil)
      product_qty_select.select(qty) if qty
      add_to_cart_button.click

      header.WaitForMicroCartToDisplay

      ProductPage_B.new
    end

    def VerifyItemAddedToCart
      product_txt = product_name.text(:visible)

      cart = ShoppingCartSplitter.new
      cart.load
      cart.CartType.VerifyItemsInCart [product_txt]

      product_txt
    end

    def VerifyItemAddedToMiniCart
      product_txt = product_name.text(:visible)
      header.mini_cart.VerifyItemInMiniCart(product_txt)
    end

    def UpdateSizeQty(size, qty)
      product_size_select.select(size) if size
      product_qty_select.select(qty) if qty

      ProductPage_B.new
    end

    def VerifySearchElements
      self.header.should be_all_there
    end

    # Applies to only VMF products
    def GoToVMFVendorPage
      vmf_vendor_section.vendor_page_link.click

      ShopByVendorPage.new
    end

    def wait_for_elements
      wait_until_product_image_visible
      wait_until_qty_options_visible
    end

    def DiscountChecker
      correctDiscountDisplayed
      price = product_price.text.delete("$").to_f
      msrp = msrp_price.text.delete("$").to_f
      discount = percentOff_price.text.delete("% Off")
      discount = ("0." + discount).to_f

      expectedPrice = msrp - (msrp * discount)

      if price.equal?expectedPrice
        $logger.Log("Product Price: " + price.to_s + " matches expected price with discount")
        correctDiscountDisplayed = true
      else
        $logger.Log("Product Price: $" + price.to_s + " should be: $" + expectedPrice.to_s + ". MSRP: $" + msrp.to_s + " with " + percentOff_price.text)
        correctDiscountDisplayed = false
      end
      return correctDiscountDisplayed
    end

  end
end