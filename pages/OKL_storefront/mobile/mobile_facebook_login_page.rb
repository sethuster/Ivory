
module Pages
  class MobileFacebookLoginPage < BasePage
    set_url 'http://www.facebook.com/login.php'
    element :email_field, 'input[name=email]'
    element :password_field, 'input[name=pass]'
    element :login_button, 'input[type=submit]'
    element :cancel_button, 'button',:text=>'Cancel'

    def Login email, pass
      wait_until_email_field_visible
      email_field.set email
      password_field.set pass
      login_button.click
    end

    def LoginAs email, pass
      Login(email, pass)
      MobileFacebookMainPage.new
    end

    def LoginToShare email, pass
      Login(email, pass)

      MobileFacebookShareModalPage.new
    end

  end
end

