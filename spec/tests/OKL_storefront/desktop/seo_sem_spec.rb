require 'storefront_spec_helper'

#2 Tests
feature 'SEO and SEM' do
  before(:all) do
    @email = PROTOTEST_OKL_EMAIL
    @password = OKL_USER_PASSWORD
    @firstname = OKL_USER_FIRST_NAME
    @lastname = OKL_USER_LAST_NAME
  end

  scenario 'Discover' do
    @page = LoginPage.new
    @page.load
    @page.LoginWithInfo(@email, @password)
    sleep 2
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
    @page = LoginPage.new
      @page.load
      @page.LoginWithInfo(@email, @password)
      sleep 2
    @page = BrowsePage.new
    visit('/browse/floor-coverings/4533')
    @page.wait_for_elements
  end
end

