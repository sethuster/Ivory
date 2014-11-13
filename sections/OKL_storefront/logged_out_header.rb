module Sections
  include Pages
  class LoggedOutHeader < BaseSection
    element :invite_friends_link,".invite-friends"
    element :log_in_link, 'a', :text=>'LOG IN'
    element :sign_up_link, 'a', :text=>'SIGN UP'
    #element :logo_link,'a',:text=>"One Kings Lane"
    #element :search_field,'.search-field'
    #element :search_button, '.search-icon'
    #element :shopping_cart_link, '#micro-cart-container'

    #element :todays_sales_link,:link,:text=>"Today's Sales"

    def GoToSales
      all_sales_link.click
      HomePage.new
    end

    def GoToLogo
      logo_link.click
      HomePage.new
    end

    def GoToVintage
      vintage_link.click
      TodaysArrivalsPage.new
    end

    def GoToUpcomingSales
      upcoming_sales.link.click
      CalendarPage.new
    end

    def GoToStyleBlog
      style_blog.click
      LiveLoveHomePage.new
    end

    def GoToLogIn
      log_in_link.click
      LoginPage.new
    end


    def SignUp
      sign_up_link.click
      JoinPage.new
    end

    def SearchFor text
      search_fieid.set text
      search_button.click
      SearchResultsPage.new
    end
  end
end
