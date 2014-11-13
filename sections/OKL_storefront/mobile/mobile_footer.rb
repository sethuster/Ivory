module Sections
  class MobileFooter < BaseSection
    element :upcoming_sales_link, 'a', :text => 'UPCOMING SALES'
    element :join_now_link, 'a', :text => 'JOIN NOW'
    element :log_in_link, 'a', :text => 'LOG IN'
    element :help_link, 'a', :text => 'help'
    element :non_mobile_link, 'a', :text => 'non-mobile version'
    element :terms_link,'a',  :text => 'terms'
    element :privacy_link, 'a', :text=> 'privacy'
    element :my_account_link, 'a', :text=>'MY ACCOUNT'
    element :log_out_link, 'a', :text=>'LOG OUT'


    def VerifyLoggedIn
      self.should have_log_out_link
      self
    end

    def LogOut
      log_out_link.click
      MobileHomePage.new
    end

    def VerifyLoggedInFooterLinks
      link_results = [
          verify_link(:upcoming_sales_link, 'CALENDAR'),
          verify_link(:my_account_link, 'Personal Information'),
          verify_link(:help_link, 'Help'),
          verify_link(:terms_link, 'Terms of User'),
          verify_link(:privacy_link, 'Privacy Policy'),
          verify_link(:log_out_link, 'MEMBER LOGIN'),
          verify_link(:non_mobile_link, 'INVITE FRIENDS & GET $15')
      ]

      failed_elements = link_results.map do |element, text, correct|
        next if correct
        "Link \"#{element}\" lead to a page which did not contain the expected text: \"#{text}\""
      end

      # the link_results.map call will always have at least one element in it, and it should be nil
      if failed_elements.length > 0 and not failed_elements[0].nil?
        fail(failed_elements.join('\n'))
      end
    end

    private
    def verify_link(element, text, pre_fn=nil)
      if not pre_fn.nil?
        pre_fn.call()
      end

      self.send(element).click
      correct_page = page.has_text? text
      page.go_back

      [element, text, correct_page]
    end
  end
end