
module Pages
  class HomePage<BasePage
    attr_reader :header
    include Sections
    set_url "/"
    section :header, LoggedInHeader, '.okl-header'
    section :footer, LoggedInFooter, '#footer'

    def wait_for_elements
      wait_until_header_visible

      self
    end

    def LogOut
      header.LogOut
      LoginPage.new
    end

    def WaitForSessionToExpire
      $logger.Log("#{__method__}(): Waiting for 20 minutes to verify session has expired")
      sleep (20*60)
      visit(current_path) #refresh after timeout

      self
    end
  end

end