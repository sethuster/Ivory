=begin
CreatedBy: Seth urban
Purpose: This class is going to be used to for the A-B shopping cart split tests
The shopping cart pages are being split - some new users are getting the new cart
some users are getting the old cart - this page ensure's that the proper cart page is
used for tests without having to query the database.
=end
module Pages
  class ShoppingCartSplitter<BasePage
    #this should not exist on the PDP_Bsplit
    element :bCartIndicator, '.okl-content'
    set_url '/cart'

    def CartType
      using_wait_time 5 do
        if self.has_bCartIndicator?
          self.DeliverBCart
        else
          self.DeliverACart
        end
      end
    end


    def DeliverACart #this is the old cart
      ShoppingCartPage.new
    end
    def DeliverBCart #this is the new cart
      ShoppingCartPageB.new
    end


  end

  ############################ Common Repeatable Actions ########################

  def remove_all_items_from_cart
    page = ShoppingCartSplitter.new
    page.load
    page.CartType.RemoveAllItemsFromCart

  end
end