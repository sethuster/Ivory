require 'OKL_storefront_spec_helper'



feature 'Smoke Tests' do

# run this once before all of the scenarios
  before(:all) do
    @rand = rand(1000).to_s
    @rand2 = rand(1000).to_s
    @mobile_email = "mobile_testuser" + @rand + @rand2 + "@mailinator.com"

    @password = OKL_USER_PASSWORD
    @firstname = OKL_USER_FIRST_NAME
    @lastname = OKL_USER_LAST_NAME
    @fullname = "#{@firstname} #{@lastname}"
  end

  before(:each) do
    @rand = rand(1000).to_s
    @rand2 = rand(1000).to_s
    @email = "testuser" + @rand + @rand2 + "@mailinator.com"

    # register the user
    register_user(@firstname, @lastname, @password, @email)
  end


  scenario 'Desktop Smoke Test', desktop: true, ipad: true do
    save_payment_info = false
    use_shipping_address = true

    shipping_info = {:first => @firstname,
                     :last => @lastname,
                     :address1 => ADDRESS1,
                     :city => CITY,
                     :state => STATE,
                     :state_abbr => STATE_ABBR,
                     :zip => ZIP,
                     :phone => PHONE}

    billing_info = {:fullname => @fullname,
                    :credit_card_num => VISA_TEST_CC,
                    :exp_month => CC_EXP_MONTH,
                    :exp_year => CC_EXP_YEAR,
                    :cvc => VISA_TEST_CCV}
    login(@email, @password)
    @page = HomePage.new
    @page.load
    @page.header.SearchFor("item").
        GoToFirstProduct(:available).
        AddToCart.
        header.GoToCart.
        CheckOutNow.
        EnterShippingDetails(shipping_info).
        Continue.
        EnterBillingInfo(billing_info, save_payment_info, use_shipping_address).
        Continue.PlaceOrder.VerifyOrderCompleted

  end

  scenario 'Vintage Item Purchase', desktop: true, ipad: true do
    save_payment_info = false
    use_shipping_address = true

    shipping_info = {:first => @firstname,
                     :last => @lastname,
                     :address1 => ADDRESS1,
                     :city => CITY,
                     :state => STATE,
                     :state_abbr => STATE_ABBR,
                     :zip => ZIP,
                     :phone => PHONE}

    billing_info = {:fullname => @fullname,
                    :credit_card_num => VISA_TEST_CC,
                    :exp_month => CC_EXP_MONTH,
                    :exp_year => CC_EXP_YEAR,
                    :cvc => VISA_TEST_CCV}
    login(@email, @password)
    @page = HomePage.new
    @page.load
    @page.header.SearchFor("vintage bowl").
        GoToFirstProduct(:available).
        AddToCart.
        header.GoToCart.
        CheckOutNow.
        EnterShippingDetails(shipping_info).
        Continue.
        EnterBillingInfo(billing_info, save_payment_info, use_shipping_address).
        Continue.PlaceOrder.VerifyOrderCompleted

  end


=begin
  scenario 'Mobile Layout Smoke Test', iphone: true, desktop: true do

    shipping_info = {:first => @firstname,
                     :last => @lastname,
                     :address1 => ADDRESS1,
                     :city => CITY,
                     :state => STATE,
                     :state_abbr => STATE_ABBR,
                     :zip => ZIP,
                     :phone => PHONE}

    billing_info = {:fullname => @fullname,
                    :credit_card_num => VISA_TEST_CC,
                    :exp_month => CC_EXP_MONTH,
                    :exp_year => CC_EXP_YEAR,
                    :cvc => VISA_TEST_CCV}

    @page = MobileHomePage.new
    @page.load
    @page = @page.GoToLoginPage.LoginWithInfo(@email, @password)

    @page.header.SearbchFor("lamp").
        GoToFirstProduct(:available).
        AddToCart.
        ItemAddedModal_Checkout.
        CheckOutNow.
        EnterShippingDetails(shipping_info).
        Next.
        EnterPaymentInfo(billing_info).
        Next.PlaceOrder.VerifyOrderCompleted

  end
=end

end

