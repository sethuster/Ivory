require 'storefront_spec_helper'

feature 'Events' do

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
    @page = login(@email, @password)
    # Select a random page
    #some of the sales events pages are not working paticularly position 1 and 4
    begin
      @sale_event = @page.header.GoToCurrentSale
    end
  end

  scenario 'Sort by Lowest Price' do
    @sale_event.SortItems(:low_price)
    prices = @sale_event.PriceList
    prices.should == prices.sort
  end

  scenario 'Sort by Featured' do
    @sale_event.SortItems(:featured)
  end

  scenario 'Sort by Available Now' do
    @sale_event.SortItems(:available)
    products = @sale_event.products
    # Looking at all products, starting from the end of the product list,
    # scan until the first product not marked as "SOLD OUT".
    i = products.length - 1
    while i >= 0 do
      if products[i].text.include?('SOLD OUT')
        i = i - 1
      else
        break
      end
    end
    # From this point on, if a product is marked as "SOLD OUT", the product list is not
    # properly sorted according to availability.
    while i >= 0 do
      if products[i].text.include?('SOLD OUT')
        fail('Sold out item not at end of page.')
      end
      i = i - 1
    end
  end

  scenario 'Search shows up in header and works' do
    @sale_event.header.search_container.should have_search_field
    product_name = @sale_event.products[0].find('div.product-info h3').text
    results_page = @sale_event.header.SearchFor product_name
    results_page.should have_search_results_summary :text => product_name
  end

  scenario 'Header present, rendered correctly, verify links' do
    @sale_event.header.VerifyRenderedCorrectly
  end

  scenario 'Footer present, rendered correctly, verify links' do
    @sale_event.footer.VerifyRenderedCorrectly
  end

end