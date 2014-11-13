require 'storefront_spec_helper'


#this suite is also using a random number to generate a new user
# Changed this to match checkout spec use more logic when creating a new user
# but still leaving a breadcrumb in the database
feature 'Invite Friends' do
  before(:all) do
    #@rand = rand(1000).to_s
    @rand = lastNewUser(INVFRIENDS_NEWUSER_EMAIL_PREFIX) + 1
    @new_customer = INVFRIENDS_NEWUSER_EMAIL_PREFIX + @rand.to_s + "@mailinator.com"
    @firstname = OKL_USER_FIRST_NAME
    @lastname = OKL_USER_LAST_NAME
    @email = PROTOTEST_OKL_EMAIL
    @password = OKL_USER_PASSWORD
    @InviteMessage = "this is the message i am sending"
  end

  before(:each) { }

  after(:each) {}

  # Skip what invite?
  #scenario 'Skip Invite' do
  #  @page
  #
  #end

  scenario 'Invite Friends' do
    # Create/Verify the facebook email user account is created
    # You can only invite new customers from an account that isn't disposable
    register_user(@firstname, @lastname, @password, @email)

    @page = LoginPage.new
    @page.load

    @page.LoginWithInfo(@email, @password).header.InviteFriends

    @page = InvitePage.new
    @page.load
#    @page.should be_all_there
    @page.SendInviteToEmails(@new_customer, @InviteMessage).header.LogOut

    # Reset the session and cookies so the invitee can claim the credit
    reset_capybara


    # visit the mailinator page, with just the username, not the domain
    visit "http://mailinator.com/inbox.jsp?to=#{@new_customer.gsub(/@mailinator.com/, '')}"

    @page = MailinatorPage.new.ClickMailWithText 'shop at One Kings Lane'
    within_frame(find('#mailshowdivbody>iframe')) do
      @page.should have_text @InviteMessage
      @page.ClickXpath '//img[@alt="Accept Invitation"]'

      @page = SignupModal.new.
          VerifyInviteSignupModalDisplayed.
          EnterEmail(@new_customer).
          EnterInfo(@firstname,@lastname,@password).
          ClosePanel.header.LogOut
    end
  end

  scenario 'Search is displayed in header and works' do
    @page = LoginPage.new
    @page.load

    @page.LoginWithInfo(@email, @password).
        header.SearchFor("lamp").
        GoToFirstProduct(:available)
  end


  scenario 'Confirm credit' do
    @page = LoginPage.new
    @page.load

    @page.LoginWithInfo(@new_customer, @password).
        header.VerifyReferralAndCredits.
        header.SearchFor("lamp").
        GoToFirstProduct(:available).
        AddToCart.
        header.GoToCart.VerifyReferralCreditApplied
  end
end