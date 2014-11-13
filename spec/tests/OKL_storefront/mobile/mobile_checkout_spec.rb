require 'storefront_spec_helper'


=begin
def remove_all_items_from_cart
  page = MobileHomePage.new
  page.load
  page.header.GoToCart.RemoveAllItemsFromCart

end
=end

feature 'Mobile Checkout' do

# run this once before all of the scenarios
  before(:all) do
    @rand = lastNewUser(CHECKOUT_NU_MOBILE) + 1
    @email = CHECKOUT_NU_MOBILE + @rand.to_s + "@mailinator.com"
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

    @billing_info = {:fullname => @fullname,
                     :credit_card_num => VISA_TEST_CC,
                     :exp_month => CC_EXP_MONTH,
                     :exp_year => CC_EXP_YEAR,
                     :cvc => VISA_TEST_CCV}

    # register the user
    register_user(@firstname, @lastname, @password, @email)

  end

  before(:each) do
    @page = MobileHomePage.new
    @page.load
    #want to remove all the items from the cart here
    @page = @page.GoToLoginPage.LoginWithInfo(@email, @password).header.GoToCart.RemoveAllItemsFromCart.BackHome

  end

  after(:each) do
    @page = MobileHomePage.new
    @page.load
    @page.LogOut
  end

  scenario 'Verify shopping cart is initially empty' do
    @page.header.GoToCart.VerifyCartEmpty
  end

  scenario 'Add item to cart' do

    @page.header.SearchFor(@item_to_search_for).
        GoToFirstProduct(:available).
        AddToCart.
        VerifyItemAddedToCart

  end


  scenario 'Remove item from cart' do

    product_name = @page.header.SearchFor(@item_to_search_for).
        GoToFirstProduct(:available).
        AddToCart.
        VerifyItemAddedToCart

    @page = MobileCartPage.new
    @page.load
    @page.RemoveItemFromCart(product_name).VerifyItemRemovedFromCart(product_name)

  end

  scenario 'Can change quantity' do
    item_quantity = 2

    @page.header.SearchFor(@item_to_search_for).GoToFirstProduct(:available).AddToCart.VerifyItemAddedToCart

    @page = MobileCartPage.new
    @page.ChangeVerifyItemQuantityUpdated(item_quantity)

  end

  scenario 'Can add new shipping address and new credit card in checkout flow' do

    @page.header.SearchFor(@item_to_search_for).
        GoToFirstProduct(:available).
        AddToCart.
        ItemAddedModal_Checkout.
        CheckOutNow.
        EnterShippingDetails(@shipping_info).
        Next.
        EnterPaymentInfo(@billing_info).
        Next.VerifyAddressAndCreditCardAdded(@shipping_info, @billing_info)

  end

  scenario 'Checkout with saved address and saved credit card in checkout flow' do
    shipping_info_saved = true
    credit_info_saved = true

    @page.header.SearchFor(@item_to_search_for).
        GoToFirstProduct(:available).
        AddToCart.
        ItemAddedModal_Checkout.
        CheckOutNow(shipping_info_saved, credit_info_saved).
        PlaceOrder.VerifyOrderCompleted

  end

  scenario 'Checkout with gift message' do
    shipping_info_saved = true
    credit_info_saved = true
    gift_msg = "I love you man"

    @page.header.SearchFor(@item_to_search_for).
        GoToFirstProduct(:available).
        AddToCart.
        ItemAddedModal_Checkout.
        CheckOutNow(shipping_info_saved, credit_info_saved).
        AddGiftMessage(gift_msg).
        PlaceOrder.VerifyOrderCompleted
  end

  scenario 'Can checkout with PayPal' do

    mobile_site = true

    @page.header.SearchFor(@item_to_search_for).
        GoToFirstProduct(:available).
        AddToCart.
        ItemAddedModal_Checkout.
        PayWithPaypal.
        LoginToPayPal.
        CompletePayPalCheckout(mobile_site).
        VerifyPayPalPaymentMethod.
        PlaceOrder.VerifyOrderCompleted

  end


  scenario 'Verify order comes through in Database' do
    shipping_info_saved = true
    credit_info_saved = true

    order_id = @page.header.SearchFor(@item_to_search_for).
        GoToFirstProduct(:available).
        AddToCart.
        ItemAddedModal_Checkout.
        CheckOutNow(shipping_info_saved, credit_info_saved).
        PlaceOrder.VerifyOrderCompleted

    # Give the AX some time to process
    sleep 10

    if order_id.nil?
      raise "Failed to get the order ID from the confirmation page"
    else
      verify_order_in_ax(order_id)
    end

  end

end

