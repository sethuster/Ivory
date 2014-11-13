require 'storefront_spec_helper'

feature 'Mobile Events' do

# run this once before all of the scenarios
  before(:all) do
    @email = "msiwiec@mailinator.com"
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
    # Select a random sales event page
    #there's a bit of a bug--doesn't always go to the sale page...
    begin
      @sale_event = @page.GoToRandomCurrentSale
    rescue
      @sale_event = @page.GoToRandomCurrentSale
    end
  end

  scenario 'Sort by Lowest Price' do
    @sale_event.SortItems(:low_price).VerifyPriceListSortedByLowestPrice

  end

  scenario 'Sort by Featured' do
    @sale_event.SortItems(:featured)
  end

  scenario 'Sort by Available Now' do
    @sale_event.SortItems(:available)
    products = @sale_event.products_sold_out
    products.size.should == 0
  end

  scenario 'Verify Inventory Badge works and rendered correctly' do
    sold_out_products = @sale_event.products_sold_out

    if sold_out_products.empty?
      raise "Failed to find any 'SOLD OUT' badges on any products in the mobile sales event pages"
    end
  end

  scenario 'Verify Vintage Badge works and rendered correctly' do
    vintage_products = @sale_event.products_vintage

    if vintage_products.empty?
      raise "Failed to find any 'VINTAGE' badges on any products in the mobile sales event pages"
    end
  end

  scenario 'Header present and rendered correctly' do
    @sale_event.header.should have_back_button
    @sale_event.header.should have_cart_button
    @sale_event.header.should have_okl_logo
  end

  scenario 'Footer present and rendered correctly' do
    @sale_event.footer.should have_upcoming_sales_link
    @sale_event.footer.should have_my_account_link
    @sale_event.footer.should have_log_out_link
    @sale_event.footer.should have_help_link
    @sale_event.footer.should have_non_mobile_link
    @sale_event.footer.should have_terms_link
    @sale_event.footer.should have_privacy_link
  end

  scenario 'Footer links work' do
    @sale_event.footer.VerifyLoggedInFooterLinks
  end
end