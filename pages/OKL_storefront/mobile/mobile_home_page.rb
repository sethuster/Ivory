module Pages
  class MobileHomePage<BasePage
    include Sections
    set_url "/layout/mobile"
    section :header, MobileHeader, '.page-header'
    section :footer, MobileFooter, '.page-footer'

    element :new_sales_section, 'h2', :text => "Today's New Sales"
    elements :todays_sales_events, '.items.today > ul > li > a'
    elements :ending_sales_events, '.items.ending > ul > li > a'

    def GoToLoginPage
      if IPHONE
        visit "/login"
        return MobileLoginPage.new
      else
        return header.OpenMenu.GoToLogin
      end
    end

    def LogOut
      wait_until_footer_visible
      footer.LogOut

      MobileLoginPage.new.wait_for_elements
    end

    def WaitForSessionToExpire
      $logger.Log("#{__method__}(): Waiting for 20 minutes to verify session has expired")
      sleep (20*60)

      self
    end

    # Go to a current sale by its 0-indexed position in the all sales header dropdown.
    def GoToRandomCurrentSale
      wait_until_new_sales_section_visible

      # Open the sales drop down: sales aren't loaded until the drop down is visible.
      wait_for_ending_sales_events

      position = rand(ending_sales_events.size)
      $logger.Log "Navigating to sale #{ending_sales_events[position].text}"
      ending_sales_events[position].click
      MobileSalesEvent.new
    end


  end
end

