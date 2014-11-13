require 'site_prism'

module Pages
  class LoginPage < BasePage
    set_url '/login'
    attr_reader :email_field, :password_field,:log_in_button,:join_now_link,:facebook_login_link,:keep_logged_in_cbx

    # ensure email, password, login elements are the same across desktop/mobile/iphone web pages
    element :email_field, 'input[name=email]'
    element :password_field,'input[name=password]'
    element :log_in_button , :xpath, '//*[@name="sumbit" or @type="submit" ]'

    element :join_now_link , :xpath, '//input[@alt="Join Now"]'
    element :facebook_login_link , 'a',:text=>'Login with Facebook'
    element :keep_logged_in_cbx,'#remember'
    element :forgot_password_link, 'a',:text=>'Forgot Password?'

    element :email_address_field, '#forgotEmail'
    element :send_email_button , '#forgotSubmit'

    def wait_for_elements
      wait_until_email_field_visible
      wait_until_password_field_visible
      wait_until_log_in_button_visible

      self
    end

    def LoginWithInfo email, password
      wait_until_email_field_visible
      email_field.set email
      password_field.set password
      log_in_button.click
      HomePage.new
    end


    def GoToFacebookLogin
      facebook_login_link.click
      FacebookLoginPage.new
    end

    def ForgotPassword email
      forgot_password_link.click
      email_address_field.set email
      send_email_button.click
      sleep 1
    end

    def GoToJoinPage
      join_now_link.click
      SignUpPage.new
    end
  end

  ############################ Common Repeatable Actions ########################
  def login(email, password)
    page = LoginPage.new
    page.load
    page.LoginWithInfo(email, password)
  end

end
