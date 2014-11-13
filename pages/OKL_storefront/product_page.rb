module Sections
  class WhiteGloveToolTip < BaseSection
    element :close_btn, '.close'
    element :title, '.title', :text => 'White glove & home delivery shipping rate'
  end

  class WhiteGloveSection < BaseSection
    element :main_label, :xpath, ".//dt[2]"
    element :icon, :xpath, ".//dt[2]/img[contains(@src, 'whiteglove.gif')]"
    element :description, :xpath, ".//dd[2]"
    element :tool_tip_link, :xpath, ".//dd[2]/a[contains(@class, 'shippingTooltip')]"
  end

  class VMFVendorSection < BaseSection
    element :vendor_name, 'div h5'
    element :vendor_description, 'div p'
    element :vendor_page_link, 'a', :text=>"See seller's other items"
  end
end

module Pages
  class ProductPage<BasePage
    attr_reader :header, :qty_options, :size_options, :product_qty_select, :product_size_select
    attr_reader :white_glove_section, :vmf_vendor_section

    include Sections

    set_url '/product{/sale}{/product}'

    element :product_image, '.productImage'
    element :add_to_cart_button, '.addToCart'
    element :product_name, :xpath, "//h1[@class='product-name']"
    element :product_price, '#oklPriceLabel'
    element :product_qty_select, '#selectSkuQuantity'
    element :product_size_select, '.productOptionSelect'
    section :header, Sections::LoggedInHeader, '.okl-header'

    # white glove: not always displayed. Depends on whether or not the product has 'extra'
    # special shipping requirements
    section :white_glove_section, WhiteGloveSection, :xpath, "//dl[contains(@class,'shippingDetails')]"

    # present, but not visible until tool_tip_link is clicked
    section :tool_tip_modal, WhiteGloveToolTip, "#productShipping"

    # vintage seller info
    section :vmf_vendor_section, VMFVendorSection, '.ds-vmf-vendor'

    # quantity and size options (size may not be there)
    elements :qty_options, '#selectSkuQuantity > option'
    elements :size_options, :xpath, "//select[@class='productOptionSelect']/option[not(@disabled)]"

    # social sharing
    element :facebook_share_link, "a.fb-share"
    element :email_share_link,  :xpath, "//*[contains(@class,'em-share')]"
    element :pinterest_share_link, "a.pin-it"

    # Returns the product text that was shared
    def ShareViaFacebook(facebook_email, facebook_password, msg=nil)

      product_name_str = product_name.text

      facebook_share_link.click
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
      product_txt = product_name.text(:visible)

      product_qty_select.select(qty) if qty
      add_to_cart_button.click

      header.WaitForMicroCartToDisplay

      ProductPage.new
    end

    def VerifyItemAddedToCart
      product_txt = product_name.text(:visible)
      cart = ShoppingCartPage.new
      cart.load
      cart.VerifyItemsInCart [product_txt]

      product_txt
    end

    def VerifyItemAddedToMiniCart
      product_txt = product_name.text(:visible)
      header.mini_cart.VerifyItemInMiniCart(product_txt)
    end

    def UpdateSizeQty(size, qty)
      product_size_select.select(size) if size
      product_qty_select.select(qty.to_s) if qty

      ProductPage.new
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
      wait_until_qty_options_visible
      wait_until_product_image_visible

      self
    end
  end
end
