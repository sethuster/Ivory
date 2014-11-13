require 'site_prism'

module Pages
  class SignUpPage < BasePage
    set_url '/join'
    element :first_name_field, '#firstName'
    element :last_name_field, '#lastName'
    element :email_field, '#email'
    element :confirm_email_field, '#confirmEmail'
    element :password_field, '#password'
    element :referral_field, '#referringEmail'
    element :join_now_button, 'input.submit'

    def EnterInfo firstName, lastName, email, password, referrer
      first_name_field.set firstName
      last_name_field.set lastName
      email_field.set email
      confirm_email_field.set email
      password_field.set password
      referral_field.set referrer
      join_now_button.click
      wait_until_join_now_button_invisible(60)
      HomePage.new
    end
  end
end
