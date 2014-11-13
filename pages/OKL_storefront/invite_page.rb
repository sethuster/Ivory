module Pages
  class InvitePage < BasePage
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
      InvitePage.new
    end
  end
end
