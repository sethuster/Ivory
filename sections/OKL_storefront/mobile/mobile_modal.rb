module Sections
  include Pages
  class MobileCheckoutModal< BaseSection
    element :message_label, 'p'
    element :continue_button, 'a', :text=>'Continue'
    element :checkout_button, 'a', :text=>"Checkout"

    def Continue
      continue_button.click
      self
    end

    def Checkout
      checkout_button.click

    end
  end
end