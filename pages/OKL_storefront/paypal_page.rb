module Pages
  class PayPalPage < BasePage
    @@email = "buyer_1296346701_per@onekingslane.com"
    @@password = "prjx2010"


    element :login_email, '#login_email'
    element :login_email2, '#email'
    element :login_password, '#login_password'
    element :login_password2, '#password'
    element :login_btn, '#submitLogin'
    element :login_btn2, '.btn.full.continue'

    # Review your information div. AJAXified page displayed after logged in
    element :continue_btn, '#continue'
    element :continue_btn2, '#confirmButtonTop.btn.full.confirmButton'

    element :login_email, '#email'
    element :login_password, '#password'
    element :login_btn, 'input[type=submit]'

    # Review your information div. AJAXified page displayed after logged in
    element :continue_btn, '#confirmButtonTop'


    ## Class static variable accessor
    def self.email
      @@email
    end

    ## Class static variable accessor
    def self.password
      @@password
    end

    def LoginToPayPal
      sleep(3)
      if has_login_email?
        login_email.set @@email
        login_password.set @@password
        login_btn.click
      else
        wait_until_login_email2_visible(3)
        login_email2.set @@email
        login_password2.set @@password
        login_btn2.click
      end
      self
    end

    def CompletePayPalCheckout(mobile_site=false)
      sleep(3)
      if has_continue_btn?
        continue_btn.click
      else
        wait_until_continue_btn2_visible(3)
        continue_btn2.click
      end

      if mobile_site
        return MobileReviewOrderPage.new
      else
        return ReviewOrderPage.new
      end
    end

  end
end