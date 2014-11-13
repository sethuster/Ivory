require 'iTriage_spec_helper.rb'

feature 'iTriage Code Test' do

  scenario 'Navigation Test' do
    @page = HomePage.new
    @page.load
    @page.navigationBar.ClickSymptoms.SelectAbdomen.VerifySymptomNotPresent("Black stools").SelectSymptom("Black stools")
  end




end