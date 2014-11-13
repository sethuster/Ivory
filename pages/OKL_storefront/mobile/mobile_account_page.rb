module Pages
  class MobileAccountPage<BasePage

    element :full_site_button, 'a', :text=>'Full Site'

    #if you are not logged in
    element :log_in_button, 'a', :text=>'Log In/Sign Up'
    element :about_us_button, 'a', :text=>'About Us'

    #if you are logged in
    element :my_account_button, 'a', :text=>'My Account'
    element :log_out_button, 'a', :text=>'LOG OUT'


    def GoToLogin
      log_in_button.click
      MobileLoginPage.new
    end

    def LogOut
      log_out_button.click
      MobileLoginPage.new
    end

    def GoToFullSite
      full_site_button.click
      HomePage.new
    end

    def GoToMyAccount
      my_account_button.click
      MyAccountInformationPage.new
    end


  end
end
