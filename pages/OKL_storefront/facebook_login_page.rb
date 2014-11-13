require 'site_prism'

module Pages
  class FacebookLoginPage < BasePage
    set_url 'http://www.facebook.com/login.php'
    element :email_field, '#email'
    element :password_field, '#pass'
    element :login_button, '#u_0_1'
    element :okay_button, 'input[type=submit]'
    element :cancel_button, 'button',:text=>'Cancel'

    def Login email, pass
      wait_until_email_field_visible
      email_field.set email
      password_field.set pass
      login_button.click

      okay_button.click if has_okay_button?
      FacebookMainPage.new
    end

    def LoginAs email, pass
      Login(email, pass)
      HomePage.new.wait_for_elements
    end

    def LoginToShare email, pass
      Login(email, pass)

      FacebookShareModalPage.new
    end

  end
end

