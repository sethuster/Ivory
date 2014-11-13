module Sections
  class MyAccountTabsSection < BaseSection
    element :account_info_link, :xpath, "//a[contains(text(), 'Account Information')]"
    element :orders_link, :xpath, "//a[contains(text(), 'Orders')]"
    element :credit_offers_link, :xpath, "//a[contains(text(), 'Credits & Offers')]"
    element :email_prefs_link, :xpath, "//a[contains(text(), 'Email Preferences')]"
    element :invitations_link, :xpath, "//a[contains(text(), 'Invitations')]"

    def GoToOrders
      orders_link.click

      MyAccountOrdersPage.new
    end

  end
end