require 'storefront_spec_helper'


feature 'AdhocTests' do

  before(:all) do
    @email = "TestUser_1104_6@mailinator.com"
    @password = "Proto123!"
  end

  before(:each) do
    @page = login(@email, @password)
  end

  after(:each) do

  end

=begin
  scenario 'ExpiredCart' do
    @page = NewExpiredCartPage.new
    @page.load
    @page.ReturnToHome

  end
=end

  scenario 'GetProductName' do
    @page = NewExpiredCartPage.new
    @page.load
    @page.GetProductName
  end

end