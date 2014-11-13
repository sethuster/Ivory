require 'storefront_spec_helper'


feature 'Vintage Market Find (VMF)' do

# run this once before all of the scenarios
  before(:all) do
    @newUser = lastNewUser(VMF_NEWUSER_EMAIL_PREFIX) + 1
    @email = VMF_NEWUSER_EMAIL_PREFIX + @newUser.to_s + "@mailinator.com"
    @password = OKL_USER_PASSWORD
    @firstname = OKL_USER_FIRST_NAME
    @lastname = OKL_USER_LAST_NAME
    @fullname = "#{@firstname} #{@lastname}"

    # register the user
    register_user(@firstname, @lastname, @password, @email)

  end

  before(:each) do
    @page = login(@email, @password)
  end

  after(:each) do

  end

  scenario 'Header and page renders correctly' do
    @page.header.GoToVintage
    @page.header.VerifyRenderedCorrectly
  end

  scenario 'Badges: Inventory - Sold Out tag visible' do
    @page = HomePage.new
    @page.load

    @page = @page.header.SearchFor("Vintage").
        GoToFirstProduct(:sold_out)

    @page.should have_text("SOLD OUT")
  end

  scenario 'Badges: Vintage tag is visible for vintage items' do
    @page = HomePage.new
    @page.load

    @page = @page.header.SearchFor("Vintage").
        GoToFirstProduct(:available_vintage)
    @page.wait_until_vmf_vendor_section_visible
  end

  scenario 'Today\'s Arrival Carousel Works' do
    @page.header.GoToVintage.
        VerifyCarouselPosition(:first).
        MoveCarouselBack.
        VerifyCarouselPosition(:first).
        MoveCarouselForward.
        VerifyCarouselPosition(:second).
        MoveCarouselForward.
        VerifyCarouselPosition(:third).
        MoveCarouselForward.
        VerifyCarouselPosition(:third)
  end

  scenario 'Shop by Vendor link works on product detail page (PDP)' do
    @page = @page.header.GoToVintage.GoToFirstProduct

    @page.wait_until_vmf_vendor_section_visible

    vmf_vendor_name = @page.vmf_vendor_section.vendor_name.text
    @page.GoToVMFVendorPage.VerifyVendorPageDisplayed(vmf_vendor_name)
  end

end

