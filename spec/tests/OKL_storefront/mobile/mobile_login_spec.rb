require 'storefront_spec_helper'

feature 'Mobile User Login' do
  before(:all) do
    @rand = rand(1000).to_s
    @rand_username = "testuser" + @rand
    @rand_username2 = "testuser" + @rand + @rand
    @newemail =  @rand_username + "@mailinator.com"
    @newemail2 =  @rand_username2 + "@mailinator.com"
    @email = PROTOTEST_OKL_EMAIL
    @facebookemail = FACEBOOK_EMAIL
    @facebookpassword = FACEBOOK_PASSWORD
    @password = OKL_USER_PASSWORD
    @firstname = OKL_USER_FIRST_NAME
    @lastname = OKL_USER_LAST_NAME

    # register the initial existing user
    register_user(@firstname, @lastname, @password, @email)
  end

  before(:each) do
    @page = MobileHomePage.new
    @page.load
  end

  scenario 'Join as new User' do
    @page = SignUpPage.new
    @page.load
    @page.EnterInfo(@firstname,@lastname,@newemail,@password,'')
    @page = MobileHomePage.new
    @page.LogOut
  end

  scenario 'Login as Existing Member' do
     @page.GoToLoginPage.LoginWithInfo(@email, @password).footer.LogOut
  end

  scenario 'Login with Facebook' do
    @page.GoToLoginPage.
        GoToFacebookLogin.
        LoginAs(@facebookemail,@facebookpassword)

    @page = MobileHomePage.new
    @page.LogOut
  end


  scenario 'Forgot Password' do
    new_password = "Test123!"

    @page.GoToLoginPage.ForgotPassword @newemail
    @page = MailinatorPage.new
    @page.load(username: @rand_username)
    @page.ClickMailWithText 'Please Reset Your One Kings Lane Password'

    within_frame(find('#mailshowdivbody>iframe')) do
      @page.ClickBodyText 'Click here to reset your password'
      @page = ResetPasswordPage.new
      @page.ResetPasswordTo(new_password)
      @page = MobileHomePage.new
      @page.LogOut
    end
  end

  scenario 'Invite Friends' do
    @page.
        GoToLoginPage.
        LoginWithInfo @email, @password
    sleep 2
    @page = InvitePage.new
    @page.load
    @page.SendInviteToEmails @newemail2, 'this is the message i am sending'

    @page = MailinatorPage.new
    @page.load(username:@rand_username2)
    @page.ClickMailWithText 'shop at One Kings Lane'

    within_frame(find('#mailshowdivbody>iframe')) do
      @page.ClickXpath '//img[@alt="Accept Invitation"]'
      sleep 2
      @page = MobileHomePage.new
      @page.LogOut
    end
  end

  scenario '/Login' do
    @page = MobileLoginPage.new
    @page.load

    @page.LoginWithInfo(@email, @password).LogOut

  end

end
