require 'site_prism'
require 'register_modal'
require 'login_modal'

module Pages
  class SignupModal < BasePage
    attr_reader :email_field,:shop_new_button,:login_button,:okl_logo
      element :email_field,'#email'
      element :shop_now_button, :xpath, "//*[@type='submit']"
      element :login_button, 'a[data-panel=modalSignup-login]'
      element :okl_logo, '.intro'
      #element :error_label, :xpath, "//div/p/span[contains(@class,'error')]"
      element :error_label, '.error'

      # invitee referral image and text (displayed if a customer was invited)
      element :invite_img, '.savingsSeal'
      element :invite_disclaimer_label, :xpath, "//*[contains(text(), 'Applies to first purchase of $30 or more')]"
    element :test , '.test'
    set_url ''

    @sLoad
    @eLoad

    def wait_for_elements
      wait_until_email_field_visible
      wait_until_shop_now_button_visible
      self
    end

    def  EnterEmail (username)
      @sLoad = Time.now
      email_field.set username
      shop_now_button.click

      sleep 1

      using_wait_time 5 do
        if has_error_label? and error_label.text.include?("This email is already a registered member")
          return SignupModal.new.wait_for_elements
        else
          return RegisterModal.new.wait_for_elements
        end
      end
    end

    def GoToLoginPage
      #sleep 2
      login_button.click
      #sleep 2
      LoginModal.new
    end

    def VerifyInviteSignupModalDisplayed
      wait_until_invite_img_visible
      wait_until_invite_disclaimer_label_visible

      wait_for_elements

      self
    end
  end
end
