require 'storefront_spec_helper'

# Defect Regression Spec
# CreatedBy: Seth Urban
# Purpose: This suite of tests will test previously found defects to verify they are fixed
# in a new versions.
#
# IMPORTANT: Keep a note of JIRA defect numbers as comments in each spec
# if the defect re-appears, re-open the original defect or at least link to it in JIRA
#
# Tests should fail if the defect exists - Tests without defects pass

feature 'Defect Regression' do
before(:all) do
  @rand = lastNewUser(DEFECT_NEWUSER_) + 1
  @email = DEFECT_NEWUSER_ +  @rand.to_s + "@mailinator.com"
  @password = OKL_USER_PASSWORD
  @firstname = OKL_USER_FIRST_NAME
  @lastname = OKL_USER_LAST_NAME
  @fullname = "#{@firstname} #{@lastname}"
  @item_to_search_for = "nightstand"

  @shipping_info = {:first => @firstname,
                    :last => @lastname,
                    :address1 => ADDRESS1,
                    :city => CITY,
                    :state => STATE,
                    :state_abbr => STATE_ABBR,
                    :zip => ZIP,
                    :phone => PHONE}

  @billing_address = @shipping_info.clone
  @billing_address[:zip] = "123"

  @billing_info = {:fullname => @fullname,
                   :credit_card_num => VISA_TEST_CC,
                   :exp_month => CC_EXP_MONTH,
                   :exp_year => CC_EXP_YEAR,
                   :cvc => VISA_TEST_CCV}

  register_user(@firstname, @lastname, @password, @email)

end

before(:each) do
  @page = login(@email, @password)

end

  scenario 'Checkout: Payment Method: CC-331' do
    saved_shippinfo = true
    saved_paymentinfo = false
    #Preconditions for test: Save valid shipping information
    @page.header.AccountInfo.AddShippingAddress.EnterShippingDetails(@shipping_info).SaveShippingInfo.header.GoToLogo
    #Start Test
    @page.header.SearchFor(@item_to_search_for).GoToFirstProduct(:available).AddToCart.header.GoToCart.CheckOutNow(saved_shippinfo, saved_paymentinfo)
    .EnterBillingInfo(@billing_info, true, false).EnterBillingAddressAndPhone(@billing_address).ContinueWithBadAddress.CheckforErrorText.EnterBillingAddressAndPhone(@shipping_info)
    .Continue.VerifyAddressAndCreditCardAdded(@shipping_info, @billing_info)

  end

end