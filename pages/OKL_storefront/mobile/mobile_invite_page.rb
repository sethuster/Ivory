module Pages
  #This page does not exist on Mobile Site yet -04.17.2014
  class MobileInvitePage < BasePage
    attr_reader :header

    element :emails_textarea, '#emailAddresses'
    element :send_invites_button, '.invite'
    element :message_textarea, '#emailMessage'
    section :header, LoggedInHeader, '.okl-header'

    set_url '/invite'


    def SendInviteToEmails (addresses, message=nil)
      sleep 1
      emails_textarea.set addresses
      sleep 1
      if(message!=nil)
        message_textarea.set message
      end
      sleep 1
      send_invites_button.click
      sleep 1
      MobileInvitePage.new
    end
  end
end