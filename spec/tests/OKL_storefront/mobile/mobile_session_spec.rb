require 'storefront_spec_helper'

feature 'Mobile Session' do
  before(:all) do
    @rand = rand(1000).to_s
    @email = "testuser" + @rand + "@mailinator.com"
    @password = OKL_USER_PASSWORD
    @firstname = OKL_USER_FIRST_NAME
    @lastname = OKL_USER_LAST_NAME

    # register the user
    register_user(@firstname, @lastname, @password, @email)
  end

  before(:each) do
    @page = MobileHomePage.new
    @page.load
    @page = @page.GoToLoginPage.LoginWithInfo(@email, @password)
  end

  scenario 'Cart Session Expiration' do
    @page = @page.header.SearchFor 'table'
    @page = @page.GoToFirstProduct(:available).AddToCart
    @page = MobileCartPage.new
    @page.load
    $logger.Log("Waiting for 10 minutes to verify shopping cart session has expired")
    sleep (60 * 10)
    @page.should have_item_reservation_duration :text=>'00:00'
  end

  scenario 'Auth Session Expiration' do
    @page = @page.WaitForSessionToExpire.header.OpenMenu
    @page.header.should be_all_there
    @page.should have_text "Log In/Sign Up"
  end
end