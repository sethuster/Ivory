require 'base_section'

module Sections
  class MiniCartRowSection < BaseSection
    element :name, :xpath, ".//h5"
    element :qty, '.quantity'
    element :price, '.price'

    def to_s
      $logger.Log("\nShopping Cart Modal \nitem_name: #{name.text} \n item_qty: #{qty.text} \n item_price: #{price.text} \n")
    end
  end

  class ShoppingCartModal < BaseSection
    element :root_container, '.micro-cart'
    element :countdown_timer, 'countdown'

    sections :mini_cart_items, MiniCartRowSection, :xpath, ".//ul[@class='cart-lines']/li"

    ### items is an array of product text ###
    def VerifyItemInMiniCart(product_name)
      product_found = false

      mini_cart_items.each do |cart_item|
        cart_item.to_s
      end

      mini_cart_items.each do |cart_item|
        if cart_item.name.text.eql?(product_name)
          product_found = true
          $logger.Log("Found #{product_name} in the mini cart")
        end
      end

      if not product_found
        raise "Failed to verify #{product_name} was added to the mini cart"
      end
    end
  end
end