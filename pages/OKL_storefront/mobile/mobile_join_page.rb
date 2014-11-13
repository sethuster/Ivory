module Pages
  class MobileJoinPage < BasePage
    set_url '/join'

    element :first_name_field, 'input[name=firstName]'
    element :last_name_field, 'input[name=lastName]'
    element :email_field, 'input[name=email]'
    element :password_field, 'input[name=password]'
    element :join_now_btn, :xpath, "//button[@type='submit']"

    def EnterInfo(first_name, last_name, email, password)
      wait_until_first_name_field_visible
      wait_until_join_now_btn_visible

      first_name_field.set first_name
      last_name_field.set last_name
      email_field.set email
      password_field.set password
      join_now_btn.click

      MobileHomePage.new
    end
  end
end
