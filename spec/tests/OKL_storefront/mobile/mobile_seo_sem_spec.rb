require 'storefront_spec_helper'


feature 'Mobile SEO and SEM' do
  before(:all) do
    @email = PROTOTEST_OKL_EMAIL
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

  scenario 'Discover' do
    @page = DiscoverPage.new
    @page.load
    @page.should have_title_label
    @page.should have_description_label
    @page.should have_sort_by_best_sellers_link
    @page.should have_sort_by_price_link
    @page.should have_products
    @page.should have_event_container
    @page.should have_see_all_sales_link
  end

  scenario 'Browse' do
    @page = BrowsePage.new
    visit('/browse/floor-coverings/4533')
    @page.wait_for_elements
  end
end

