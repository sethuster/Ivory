module Sections
  class NavigationBar<BaseSection
    element :symptoms, '#Avatar a'
    element :doctors, '#Doctors a'
    element :facilities, '#Facilities a'
    element :conditions, '#Conditions a'
    element :medications, '#Medications a'
    element :procedures, '#Procedures a'
    element :myiTriage, '##My-iTriage a'
    element :news, '#News'

    def ClickSymptoms
      symptoms.click
      AvatarPage.new
    end
  end
end