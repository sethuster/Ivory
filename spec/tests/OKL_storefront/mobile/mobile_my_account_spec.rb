require 'storefront_spec_helper'


feature 'Mobile My Account' do

# run this once before all of the scenarios
  before(:all) do
    @rand = rand(1000).to_s
    @email = "testuser" + @rand + "@mailinator.com"
    @password = OKL_USER_PASSWORD
    @firstname = OKL_USER_FIRST_NAME
    @lastname = OKL_USER_LAST_NAME
    @fullname = "#{@firstname} #{@lastname}"

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
    @page = @page.GoToLoginPage.LoginWithInfo(@email, @password).header.OpenMenu.GoToMyAccount
  end

  after(:each) do
    sleep 4
  end

  scenario 'Add credit card to account' do
    @page.AddPaymentMethod.
        EnterBillingInfo(@billing_info).
        EnterBillingAddressAndPhone(@shipping_info).
        SavePaymentInfo.
        VerifyPaymentAdded(@billing_info)
  end

  scenario 'Remove credit card from account' do
   @page.RemovePaymentMethod(@billing_info).
        VerifyPaymentMethodRemoved(@billing_info)
  end

  scenario 'Add shipping address to account' do
    @page.AddShippingAddress.
        EnterShippingDetails(@shipping_info).
        SaveShippingInfo.
        VerifyShippingInfoAdded(@shipping_info)
  end

  scenario 'Remove shipping address from account' do
    @page.RemoveShippingInfo(@shipping_info).
        VerifyShippingInfoRemoved(@shipping_info)
  end

  scenario 'Verify my orders link works' do
    @page.account_tabs.GoToOrders
  end

end

