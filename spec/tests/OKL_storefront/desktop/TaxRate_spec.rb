require 'storefront_spec_helper'

# Tax Rate
# CreatedBy: Seth Urban
# Purpose: This test suite will verify that the appropriate tax rate is applied to the customer's order
#
# Tax Rates are discovered through the zip2Tax database on the QA environment we've attached too

feature 'Tax Rate Calculations' do
  before(:all) do
    #This sets up the data we want to test on
    @customerDS = CustomerDS.new.GatherZipCodeData #this is an array of Customer_tax_records
    @custFname = "TRT_Fname"
    @custLname = "TRT_Lname"
    @custEmail = TAXRATE_USER
    @time = Time.new
    @itemToSearchFor = "pots"
    @password = OKL_USER_PASSWORD
    @TaxMan = VerifyTax.new
  end

  #TODO build a method to write flat file

  scenario 'Tax Rate Test' do
    #this test is is going to be repeated X number of times
    # X = number of customer records
    num = 0

    begin
        #Set Up the customer data
        @custFname += num.to_s
        @custLname += num.to_s
        #want to make this unique enough so it should never exist twice in the database
        @custEmail = @custEmail + num.to_s + "_" + @time.yday.to_s + @time.hour.to_s + @time.min.to_s + "@mailinator.com"
        #now we need to set up some shipping and payment info for each customer
        shipping_info = {
            :first => @custFname,
            :last => @custLname,
            :address1 => ADDRESS1,
            :city => @customerDS[num].GetCity,
            :state => @customerDS[num].GetState,
            :state_abbr => @customerDS[num].GetStateAbbr,
            :zip => @customerDS[num].GetZip,
            :phone => PHONE
        }
        billing_info = {
            :fullname => @custFname + " " + @custLname,
            :credit_card_num => VISA_TEST_CC,
            :exp_month => CC_EXP_MONTH,
            :exp_year => CC_EXP_YEAR,
            :cvc => VISA_TEST_CCV
        }
        #now we want to register a new user and actually add that info to their account
        register_user(@custFname, @custLname, @password, @custEmail)
        #provided that worked Let's add the stuff to the account info
        @page = login(@custEmail, @password)
        @page = MyAccountInformationPage.new
        @page.load

        @page.AddShippingAddress.EnterShippingDetails(shipping_info).SaveShippingInfo.AddPaymentMethod.EnterBillingInfo(billing_info).SavePaymentInfo
        #Now that the account has a billing and payment info added - the tax can be estimated on an order.
        #Let's create the order
        @page = HomePage.new
        @page.load

        prices = @page.header.SearchFor(@itemToSearchFor).GoToFirstProduct(:available).AddToCart.header.GoToCart.PricingInformation
        #We have the prices on the product page - let's check to make sure taxes and shipping are applied correctly
        expectedTotal = @TaxMan.ExpectedTotal(@customerDS[num].GetShippingTaxable, prices[0], prices[1], @customerDS[num].GetTaxRate).round(2)

        #TODO add the results back into the customerDS after we get the orderNumber



        #lastly cycle down the num
        num = num + 1
      end while num < @customerDS.length
      #TODO write the results down here
    end
end


