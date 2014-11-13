module Pages
  class AvatarPage<BasePage
    set_url "/avatar"
    #TODO add NavSection
    element :abdomen, 'area.Abdomen'

    def SelectAbdomen
      abdomen.click
      AvatarAbdomenSymptoms.new
    end
  end
end