module Pages
  class MobileOrderCompletedPage < SitePrism::Page

    element :close_btn, 'a', :text => 'Close'
    element :order_thank_you, :xpath, "//*[contains(text(),'Thank You!')]"
    element :order_id, '.order-id'
    elements :products, 'li.cart-line'

    def VerifyOrderCompleted
      wait_until_order_thank_you_visible
      products.size.should > 0

      # Extract the order id from the confirmation page
      begin
        return Integer(order_id.text)
      rescue Exception => e
        $logger.Log("Failed to convert order_id string to Integer")
        return nil
      end
    end


  end
end