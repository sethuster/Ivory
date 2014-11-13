module Sections
  include Pages
  class MobileHeader < BaseSection
    element :menu_button, 'p.menu a'
    element :back_button, 'p.back'
    element :cart_button, 'p.cart a'
    element :okl_logo, 'h1.page-title'

    def GoHome
      okl_logo.click
      self
    end
    def GoBack
      back_button.click
      self
    end

    def OpenMenu
      okl_logo.click
      menu_button.click
      MobileAccountPage.new
    end

    def GoToCart
      wait_for_cart_button
      cart_button.click
      MobileCartPage.new
    end

    def SearchFor text
      visit "/search?q=#{text}"

      MobileSearchResultsPage.new
    end

  end
end