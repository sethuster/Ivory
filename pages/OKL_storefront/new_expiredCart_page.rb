module Pages
  class ExpiredItemsSection < SitePrism::Section
    elements :productImageName, 'a' #first img, second product text
    element :addToCart, 'form button'
  end

  class NewExpiredCartPage < BasePage
    set_url '/cart'
    sections :expiredItems, ExpiredItemsSection, '.available ul li'
    element :expiredText, '.baskets h2'
    element :todaysSales_button, '.baskets a'
    element :okl_header_button, '.okl-cart-header a'

    def ReturnToHome
      okl_header_button.click
      HomePage.new
    end

    def GetProductName
      numitems = expiredItems.size
=begin
      expiredItems.each do |item|
        prodName = item.productImageName.last.text
      end
=end
      expiredItems.first.addToCart.click
      ShoppingCartPageB.new
    end

    

  end
end