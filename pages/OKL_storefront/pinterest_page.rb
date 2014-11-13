module Pages
  class PinterestPage < BasePage

    # Pinterest OKL board page
    set_url 'http://www.pinterest.com/bkitchener0968/okl/'

    # NOTE: These elements are contained in different modals, but they are combined
    # with one another here, for brevity's sake

    # 1st modal
    element :already_have_account_link, '.emailLogin'

    # 2nd modal
    element :login_with_facebook_link, :xpath, "//span[contains(text(), 'Facebook')]"

    def LoginToShare(facebook_email, facebook_password)
      wait_until_already_have_account_link_visible
      already_have_account_link.click

      wait_until_login_with_facebook_link_visible
      login_with_facebook_link.click

      # wait for this new window to display
      sleep 5

      # new window displayed here to allow Pinterest to post to facebook
      new_window = page.driver.browser.window_handles.last

      begin
        page.within_window new_window do
          FacebookLoginPage.new.Login(facebook_email, facebook_password)
        end
      rescue
        # nothing to handle. Simply fall-through.
        # After logging in with facebook to Pinterest, the OK button may or not
        # be visible if facebook third-party authentication with Pinterest
        # has already happened. The popup window is automatically closed and the
        # new window handle is no longer available.
      end

      PinterestPage.new
    end

    # Pinterest modal
    element :pin_it_btn, "button[type=submit].pinIt"
    element :pinned_lbl, :xpath, "//*[contains(text(), 'Pinned')]"

    def PinIt
      wait_until_pin_it_btn_visible

      pin_it_btn.click

      wait_until_pinned_lbl_visible

      PinterestPage.new
    end

  end
end