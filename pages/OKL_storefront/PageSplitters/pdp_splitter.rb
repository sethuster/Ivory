=begin
CreatedBy: Seth urban
Purpose: This class is used to determine which product detail page should be presented.
Different PDP pages are displayed depending on which split the user is assigned to.  About 20% of users
will have the new PDP page.

=end
module Pages
  class PDPSplitter<BasePage
    #this should not exist on the PDP_Bsplit
    element :legacy_FB_social_button, "a.fb-share"

    def CheckPDP
      using_wait_time 5 do
          if self.has_legacy_FB_social_button?
            self.DeliverAPDP
          else
            self.DeliverBPDP
          end
        end
    end

    def DeliverAPDP
      ProductPage.new
    end
    def DeliverBPDP
      ProductPage_B.new
    end
  end
end