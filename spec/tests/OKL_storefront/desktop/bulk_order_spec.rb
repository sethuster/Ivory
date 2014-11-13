require 'storefront_spec_helper'
require 'nexus_spec_helper'


feature 'Bulk order' do

  # Sales Events and skus under test
  $events = [ {:event_id => '43450', :okl_skus => [  'AAM13320', 'AAM13321', 'AAM13322', 'AAM13323']} ]

  before(:all)do
    @item_to_search_for="lamp"
  end

  before(:each) do
    @page = login('rsinghai@onekingslane.com', 'ruchi1234;@')

  end


  $events.each do |event|
    event[:okl_skus].each do |okl_sku_under_test|

      scenario 'Checkout specified skus from specified events ', ruchi: true do
        shipping_info_saved = true
        credit_info_saved = true
        num=0
        begin

          # Navigate to the sales event/product id under test
          product_id = get_product_id_from_okl_sku_king(okl_sku_under_test)
          @page = HomePage.new
          @page.load
          @page = ProductPage.new
          @page.load(sale:event[:event_id], product:product_id)

          # purchase
              @page.AddToCart.
              header.GoToCart.
              CheckOutNow(shipping_info_saved, credit_info_saved).
              PlaceOrder.VerifyOrderCompleted


        num+=1
        end while num <22
      end
    end
  end


end



