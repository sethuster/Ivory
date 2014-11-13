require 'storefront_spec_helper'
require 'pry'

#10 tests total

#this test seems to use 2 'new' users to run through the suite.
#changing this to not use random number to generate a 'new' user

feature 'User Login' do
  before(:all) do
    @rand = rand(1000).to_i
    #@rand_username = "testuser" + @rand
    #@rand_username2 = "testuser" + @rand + @rand
    @newUser = lastNewUser(LOGIN_NEWUSER_EMAIL_PREFIX) + @rand
    @newUser2 = @newUser + @rand
    @newUser3 = @newUser2 + @rand
    @newemail =  LOGIN_NEWUSER_EMAIL_PREFIX + @newUser.to_s + "@mailinator.com"
    @newemail2 =  LOGIN_NEWUSER_EMAIL_PREFIX + @newUser2.to_s + "@mailinator.com"
    @newemail3 = LOGIN_NEWUSER_EMAIL_PREFIX + @newUser3.to_s + "@mailinator.com"
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
    @page = SignupModal.new
    @page.load
    @page = @page.wait_for_elements
  end

  scenario 'Join as new User' do
    @page.EnterEmail(@newemail).
        EnterInfo(@firstname,@lastname,@password).
        ClosePanel
  end

  scenario 'Login as Existing Member' do
    @page.GoToLoginPage.
        LoginWithExistingInfo(@email,@password).
        LogOut
  end

  scenario 'Login with Facebook' do
    @page = LoginPage.new
    @page.load
    @page.GoToFacebookLogin.
        LoginAs(@facebookemail,@facebookpassword).
        LogOut
  end

  scenario 'Guest Pass' do
    @page = GuestHomePage.new
    @page.load
    @page.header.should be_all_there
  end

  scenario 'Forgot Password' do
    new_password = "Test123!"

    @page = LoginPage.new
    @page.load
    @page.ForgotPassword @newemail
    @page = MailinatorPage.new
    @page.load(username: LOGIN_NEWUSER_EMAIL_PREFIX + @newUser.to_s)
    @page.ClickMailWithText 'Please Reset Your One Kings Lane Password'

    within_frame(find('#mailshowdivbody>iframe')) do
      @page.ClickBodyText 'Click here to reset your password'
      sleep 5
    end

    # reset password link opens up a new window
    within_window( ->{page.title == 'One Kings Lane'} ) do
      ResetPasswordPage.new.wait_for_elements.ResetPasswordTo(new_password).LogOut
    end
  end

  scenario 'Join -a' do
    @page = SignUpPage.new
    @page.load
    @page.EnterInfo(@firstname,@lastname,@newemail3,@password,'').
        LogOut
  end

  scenario 'Join -b' do
      @page = JoinBPage.new
      @page.load
      @page.GoToLoginPage.
          LoginWithExistingInfo(@email, @password).
          LogOut
    end

    scenario 'Join -c' do
      @page = JoinCPage.new
      @page.load
      @page.GoToLoginPage.
          LoginWithExistingInfo(@email, @password).
          LogOut
    end

=begin
# THIS scenario is testing in the session_spec
  scenario 'Keep me logged in ' do
    @page

  end
=end

  scenario '/Login' do
    @page = LoginPage.new
    @page.load
    @page.LoginWithInfo(@email, @password).LogOut
    end

end

