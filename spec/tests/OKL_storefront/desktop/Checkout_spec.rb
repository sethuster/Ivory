require 'OKL_storefront_spec_helper'
#9 Tests


feature 'Checkout' do

# run this once before all of the scenarios
  before(:all) do
    @rand = lastNewUser(CHECKOUT_NEWUSER_EMAIL_PREFIX ) + 1
    @email = CHECKOUT_NEWUSER_EMAIL_PREFIX +  @rand.to_s + "@mailinator.com"
    @password = OKL_USER_PASSWORD
    @firstname = OKL_USER_FIRST_NAME
    @lastname = OKL_USER_LAST_NAME
    @fullname = "#{@firstname} #{@lastname}"
    @item_to_search_for = "lamp"

    @shipping_info = {:first => @firstname,
                      :last => @lastname,
                      :address1 => ADDRESS1,
                      :city => CITY,
                      :state => STATE,
                      :state_abbr => STATE_ABBR,
                      :zip => ZIP,
                      :phone => PHONE}

    @pobox_info = {:first => @firstname,
                   :last => @lastname,
                   :address1 => 'PO Box 420',
                   :city => CITY,
                   :state => STATE,
                   :state_abbr => STATE_ABBR,
                   :zip => ZIP,
                   :phone => PHONE}

    @pobox_corrected = @pobox_info.clone
    @pobox_corrected[:address1] = '1 POrtland Ln'

    @billing_info = {:fullname => @fullname,
                     :credit_card_num => VISA_TEST_CC,
                     :exp_month => CC_EXP_MONTH,
                     :exp_year => CC_EXP_YEAR,
                     :cvc => VISA_TEST_CCV}

    # register the user
    register_user(@firstname, @lastname, @password, @email)

  end

  before(:each) do
    @page = login(@email, @password)

    # Cleanup
    remove_all_items_from_cart
  end

  after(:each) do

  end

  scenario 'Verify shopping cart is initially empty' do
    @page = HomePage.new
    @page.load
    @page.header.GoToCart.VerifyCartEmpty
  end

  scenario 'Add item to cart' do
    @page = HomePage.new
    @page.load
    @page.header.SearchFor(@item_to_search_for).GoToFirstProduct(:available).AddToCart.VerifyItemAddedToCart

  end

  scenario 'Remove item from cart' do
    @page = HomePage.new
    @page.load
    product_name = @page.header.SearchFor(@item_to_search_for).GoToFirstProduct(:available).AddToCart.VerifyItemAddedToCart

    @page = ShoppingCartSplitter.new.CartType
    @page.RemoveItemFromCart(product_name).VerifyItemRemovedFromCart(product_name)

  end

  scenario 'Check mini cart' do
    @page = HomePage.new
    @page.load
    @page.header.SearchFor(@item_to_search_for).GoToFirstProduct(:available).AddToCart.VerifyItemAddedToMiniCart

  end

  scenario 'Can change quantity' do
    item_quantity = 2

    @page = HomePage.new
    @page.load
    @page.header.SearchFor(@item_to_search_for).GoToFirstProduct(:available).CheckQTY.AddToCart.VerifyItemAddedToCart

    @page = ShoppingCartSplitter.new.CartType
    @page.ChangeVerifyItemQuantityUpdated(item_quantity)

  end

  scenario 'Can not add new shipping address with PO Box' do
    #this test also replaces can add new shipping address test - same functionality is covered
    save_payment_info = true
    use_shipping_address = true

    @page = HomePage.new
    @page.load
    @page.header.SearchFor(@item_to_search_for).
        GoToFirstProduct(:available).
        AddToCart.
        header.GoToCart.
        CheckOutNow.
        EnterShippingDetails(@pobox_info).
        ContinueBadAddress.
        EnterShippingDetails(@pobox_corrected).
        ContinueAddressVerify.
        SelectEnteredAddress.
        EnterBillingInfo(@billing_info, save_payment_info, use_shipping_address).
        Continue.VerifyAddressAndCreditCardAdded(@pobox_corrected, @billing_info)

  end

  scenario 'Can add new shipping address and new credit card in checkout flow' do
    save_payment_info = true
    use_shipping_address = true


    @page = HomePage.new
    @page.load

    @page.header.SearchFor(@item_to_search_for).
        GoToFirstProduct(:available).
        AddToCart.
        header.GoToCart.
        CheckOutAgain.
        ChangeAddShippingDetails(@shipping_info).
        ChangePaymentMethod(@billing_info, save_payment_info, use_shipping_address).
        VerifyAddressAndCreditCardAdded(@shipping_info, @billing_info)

  end



  scenario 'Checkout with saved address and saved credit card in checkout flow' do
    shipping_info_saved = true
    credit_info_saved = true

    @page = HomePage.new
    @page.load
    @page.header.SearchFor(@item_to_search_for).
        GoToFirstProduct(:available).
        AddToCart.
        header.GoToCart.
        CheckOutNow(shipping_info_saved, credit_info_saved).
        PlaceOrder.VerifyOrderCompleted

  end


  scenario 'Checkout with gift message' do
    shipping_info_saved = true
    credit_info_saved = true
    gift_msg = "I love you man"

    @page = HomePage.new
    @page.load
    @page.header.SearchFor(@item_to_search_for).
        GoToFirstProduct(:available).
        AddToCart.
        header.GoToCart.
        CheckOutNow(shipping_info_saved, credit_info_saved).
        AddGiftMessage(gift_msg).
        PlaceOrder.VerifyOrderCompleted
  end


  scenario 'Can checkout with PayPal' do
    @page = HomePage.new
    @page.load
    @page.header.SearchFor(@item_to_search_for).
        GoToFirstProduct(:available).
        AddToCart.
        header.GoToCart.
        CheckoutWithPayPal.
        LoginToPayPal.
        CompletePayPalCheckout.
        VerifyPayPalPaymentMethod.
        PlaceOrder.VerifyOrderCompleted

  end

  scenario 'Verify order exists in King_cart' do
    shipping_info_saved = true
    credit_info_saved = true

    @page = HomePage.new
    @page.load

    order_id = @page.header.SearchFor(@item_to_search_for).
        GoToFirstProduct(:available).
        AddToCart.
        header.GoToCart.
        CheckOutNow(shipping_info_saved, credit_info_saved).
        PlaceOrder.VerifyOrderCompleted

    # Give the AX some time to process
    sleep 10

    if order_id.nil?
      raise "Failed to get the order ID from the confirmation page"
    else

      exec_str = verify_order_in_ax(order_id)

      #if not exec_str.include?(order_id.to_s)
      #  raise "Failed to verify order_id '#{order_id}' came through the AX: exec_output: #{exec_str}"
      #end

      verify_order_in_ax(order_id)

    end

  end

end

