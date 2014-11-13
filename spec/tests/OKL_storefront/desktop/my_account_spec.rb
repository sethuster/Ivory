require 'storefront_spec_helper'

#5 tests

#This test also uses a random number to create new users - suspect this test suite needs a new user account also


feature 'My Account' do

# run this once before all of the scenarios
  before(:all) do
    #@rand = rand(1000).to_s
    @newUser = lastNewUser(MYACCOUNT_NEWUSER_EMAIL_PREFIX) + 1
    @email = MYACCOUNT_NEWUSER_EMAIL_PREFIX + @newUser.to_s + "@mailinator.com"
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
    @page = login(@email, @password)
  end

  after(:each) do
    sleep 4
  end

  scenario 'Add credit card to account' do
    @page = MyAccountInformationPage.new
    @page.load

    @page.AddPaymentMethod.
        EnterBillingInfo(@billing_info).
        EnterBillingAddressAndPhone(@shipping_info).
        SavePaymentInfo.
        VerifyPaymentAdded(@billing_info)
  end

  scenario 'Remove credit card from account' do
    @page = MyAccountInformationPage.new
    @page.load

    @page.RemovePaymentMethod(@billing_info).
        VerifyPaymentMethodRemoved(@billing_info)
  end

  scenario 'Add shipping address to account' do
    @page = MyAccountInformationPage.new
    @page.load

    @page.AddShippingAddress.
        EnterShippingDetails(@shipping_info).
        SaveShippingInfo.
        VerifyShippingInfoAdded(@shipping_info)
  end

  scenario 'Remove shipping address from account' do
    @page = MyAccountInformationPage.new
    @page.load

    @page.RemoveShippingInfo(@shipping_info).
        VerifyShippingInfoRemoved(@shipping_info)
  end

  scenario 'Can NOT add shipping address with PO Box' do
    #Test to make sure that users can NOT enter a shipping address with a PO Box
    # Verify that users CAN enter address that contains the letters PO
    badShipping_info = {:first => @firstname,
                        :last => @lastname,
                        :address1 => 'PO BOX 420',
                        :city => 'Littleton',
                        :state => 'Colorado',
                        :state_abbr => 'CO',
                        :zip => '80123',
                        :phone => '3035551212'}

    goodShipping_info = badShipping_info.clone
    goodShipping_info[:address1] = '1 Portland Ln'

    @page = HomePage.new
    @page.load
    @page.header.AccountInfo.AddShippingAddress.EnterShippingDetails(badShipping_info).
        SaveBadShippingInfo.EnterShippingDetails(goodShipping_info).SaveShippingInfo

  end

  scenario 'Verify my orders link works' do
    @page = MyAccountInformationPage.new
    @page.load

    @page.account_tabs.GoToOrders
  end

end

