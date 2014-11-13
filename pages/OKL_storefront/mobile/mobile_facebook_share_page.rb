module Pages
  class MobileFacebookShareModalPage < BasePage
    element :message_text_area, '._5whq.input'
    element :product_name, "div.sharerAttachmentTitle span"
    element :share_link_btn, "#share_submit"
    element :cancel_link_btn, 'a', :text => "Cancel"

    def VerifyProductNameDisplayed(product_name_str)
      if not product_name.text.eql?(product_name_str)
        raise "Failed to verify the product title text '#{product_name_str}' is displayed in the facebook share modal popup"
      end

      self
    end

    def CancelSharing
      cancel_link_btn.click
    end

    # Optional message for sharing
    def ShareLink(msg=nil)
      message_text_area.set msg if msg
      share_link_btn.click
    end
  end
end