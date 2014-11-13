require 'welcome_splash_page'
include Pages

module Pages
  class RegisterModal< BasePage
    attr_reader :back_link,:first_name_field,:last_name_field,:password_field,:shop_today_sales_button,:log_in_link
      element :back_link,  'button', :text=> 'BACK'
      element :first_name_field,  '#firstName'
      element :last_name_field,  '#lastName'
      element :password_field,  '#password'
      #Looks like this button was changed from text => "SHOP TODAY'S SALES" to shop now
      element :shop_today_sales_button,  'button', :text => "SHOP TODAY'S SALES"
      element :log_in_link, 'a', :text=> 'LOG IN'


    set_url ''

    def wait_for_elements
      wait_until_password_field_visible
      wait_until_shop_today_sales_button_visible

      self
    end

    def EnterInfo (firstname, lastname, password)
      #first_name_field.set firstname
      #last_name_field.set lastname
      password_field.set password
      shop_today_sales_button.click
      sleep 1
      WelcomeSplashPage.new
    end

    def EnterBlankInfo
      first_name_field.set ''
      last_name_field.set ''
      password_field.set ''
      shop_today_sales_button.click
      RegisterModal.new
    end

    def Back
      back_link.click
      SignupModal.new
    end
  end

  ############################ Common Repeatable Actions ########################
  def register_user(first_name, last_name, password, email)
    if RSpec.configuration.default_browser.eql?(:iphone)
      page = MobileJoinPage.new
      page.load
      page.EnterInfo(first_name, last_name, email, password).LogOut
    else
      page = SignupModal.new
      page.load

      page = page.EnterEmail(email)

      # If the RegisterModal page is returned, then the email address is not in the system yet.
      # Continue to enter information to register the account
      if page.class.eql?(RegisterModal)
        page.EnterInfo(first_name, last_name, password).ClosePanel.LogOut
      else
        $logger.Log "The email address '#{email}' is already registered"
      end
    end
  end
end
