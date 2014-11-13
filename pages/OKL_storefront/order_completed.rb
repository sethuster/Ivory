module Pages
  class OrderCompletedPage < SitePrism::Page

    element :order_thank_you, :xpath, "//*[contains(text(),'THANK YOU FOR YOUR ORDER')]"
    element :order_id, '.orderId'
    elements :products, '.productName'

    def VerifyOrderCompleted
      wait_until_order_thank_you_visible
      wait_until_products_visible
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