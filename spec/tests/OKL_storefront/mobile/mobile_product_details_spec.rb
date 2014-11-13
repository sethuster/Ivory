require 'storefront_spec_helper'

feature 'Mobile Product Details' do

# run this once before all of the scenarios
  before(:all) do
    @email = PROTOTEST_OKL_EMAIL
    @facebookemail = FACEBOOK_EMAIL
    @facebookpassword = FACEBOOK_PASSWORD
    @password = OKL_USER_PASSWORD
    @firstname = OKL_USER_FIRST_NAME
    @lastname = OKL_USER_LAST_NAME
    @fullname = "#{@firstname} #{@lastname}"
  end

  before(:each) do
    @page = MobileHomePage.new
    @page.load
    @page = MobileLoginPage.new
    @page.load
    @page.LoginWithInfo(@email, @password)
    sleep 2
  end

  scenario 'Select Product Quantity and size' do
    @page = MobileSearchResultsPage.new
    visit("/search?q=red rug")
    # Searching for rug products typically have size and quantity
    @page.GoToFirstProduct

    qty = 2
    size = 1
    @page = MobileProductPage.new
    @page.SelectQuantity(qty)
    @page.SelectSizeByIndex(size)

  end

  scenario 'Add Product to Cart' do
    @page = MobileSearchResultsPage.new
    visit("/search?q=lamp")
    @page.GoToFirstProduct(:available).AddToCart.VerifyItemAddedToCart
  end

  scenario 'White Glove Tool Tip' do
    # Sofa's typically have the 'white glove' special shipping handling
    @page = MobileSearchResultsPage.new
    visit("/search?q=sofa")

    @page = @page.GoToFirstProduct(:available)

    # The white glove area is hidden until you click on the 'Shipping/Returns' section
    @page.shipping_returns_section.click

    @page.white_glove_section.should have_main_label
    @page.white_glove_section.should have_description

  end

  scenario 'Social Sharing - Facebook' do
    share_msg = "This item is wicked cool Facebook!"
    @page = MobileSearchResultsPage.new
    visit("/search?q=lamp")
    product_shared_str = @page.
         GoToFirstProduct(:available).
         ShareViaFacebook(@facebookemail, @facebookpassword, share_msg)

    # Verify the item was actually posted to the facebook user's wall
    @page = FacebookMainPage.new
    @page.load
    @page.GoToNewsFeed.VerifyProductShared(product_shared_str)
  end

  scenario 'Social Sharing - Pinterest' do
    @page = MobileSearchResultsPage.new
    visit("/search?q=lamp")

    product_shared_str = @page.
         GoToFirstProduct(:available).
         ShareViaPinterest(@facebookemail, @facebookpassword)

    # get into pinterest account and verify product was pinned to the okl board
    @page = PinterestPage.new
    @page.load

    @page.should have_text product_shared_str
  end

end


