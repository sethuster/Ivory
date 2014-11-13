require 'pry'

module Pages
  class LoginModal < BasePage
    attr_reader :email_field, :password_field,:log_in_button,:join_now_link,:facebook_login_link,:keep_logged_in_cbx

      set_url ''
      element :email_field, '#email'
      element :email_field2, '#email2'
      element :password_field,'#password'
      element :password_field2, '#password2'
      element :shop_now_button , 'button[type=submit]'

      element :email_field, '#email2'
      element :password_field,'#password2'
      element :log_in_button , 'button[type=submit]', :text => "LOG IN"

      element :join_now_link , '.joinLink'
      element :facebook_login_link , '.fblogin'
      element :keep_logged_in_cbx,'#remember'

    def wait_for_elements
      wait_until_email_field_visible
      wait_until_password_field_visible
      wait_until_log_in_button_visible
    end

    def LoginWithInfo email, password
      email_field.set email
      password_field.set password
      sleep 2
      log_in_button.click
      sleep 2
      HomePage.new
    end

    def LoginWithExistingInfo email, password
      email_field2.set email
      sleep 2
      password_field2.set password
      shop_now_button.click
      sleep 2
      HomePage.new
    end

    def LoginWithBlankInfo
      email_field.set ''
      password_field.set ''
      log_in_button.click
      LoginPage.new
    end

    def JoinNow
      join_now_link.click
      SignupModal.new
    end

    def GoToFacebookLogin
      sleep 2
      facebook_login_link.click
      FacebookLoginPage.new
    end
  end
end