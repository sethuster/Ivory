module Pages
  class AvatarAbdomenSymptoms<BasePage
    set_url "/avatar/male/13/abdomen"
    elements :symptomsList, '.content ul li a'

    def VerifySymptomNotPresent(symptom)
      $logger.Log("Checking Abdominal Symptoms - Verifying #{symptom} is not present")
      symptomsList.each do |absSymptom|
        sometext = absSymptom.text
        $logger.Log(sometext)
        if absSymptom.text == symptom
          raise "#{symptom} was found in the Abdominal Symptom List"
        end

      end

      self
    end

    def SelectSymptom(symptom)
      $logger.Log("Attempting to locate #{symptom} in symptom list...")
      symptomsList.each do |absSymptom|
        sometext = absSymptom.text
        $logger.Log(sometext)
        if absSymptom.text.eql?(symptom)
          absSymptom.click
        end
      end
      symptom
    end


  end
end