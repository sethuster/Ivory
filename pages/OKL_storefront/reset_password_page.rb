require 'pry'

module Pages
  class ResetPasswordPage <  BasePage
    set_url ''
    element :new_password_field, '#password'
    element :re_enter_password_field, '#confirm'
    element :reset_password_button, 'input[value=reset]'
    element :shop_all_sales_button, :xpath, '//img[contains(@src,"shopAllSales")]'

    def wait_for_elements
      wait_until_new_password_field_visible
      wait_until_reset_password_button_visible
      self
    end

    def ResetPasswordTo text
      new_password_field.set text
      re_enter_password_field.set text
      reset_password_button.click

      #shop_all_sales_button.click
      HomePage.new.wait_for_elements

    end
  end
end
