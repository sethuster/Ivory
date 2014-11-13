#CreatedBy: Seth Urban
# Purpose: collects order information regarding tax data for use in Checkout related tests
# This class is used for maintaining a list of individual records
#
# Used in Zip2Tax and Checkout Tests
require 'csv'

ZIPCODE_FILES = File.expand_path(File.join(File.dirname(__FILE__), '..', 'utilities/'))
ZIPCODE_DATABASE = 'zip2Tax'
module TaxObjects
class CustomerDS
  @ZipCode_arr
  @zipCode_query
  @CustomerTaxRecords


  def GatherZipCodeData
    zipCodesIn = ""
    CSV.foreach(File.join(ZIPCODE_FILES, "zipcodeLookup.csv")) do |row|
      @ZipCode_arr = row
    end

    zipCodesIn = @ZipCode_arr.first
    @ZipCode_arr.shift #remove the first element from the array
    @ZipCode_arr.each  do |zip|
      zipCodesIn += (", " + zip)
    end
    @zipCode_query = "Select City, \"*\", State, \"*\", County, \"*\", ZipCode, \"*\", SalesTaxRate, \"*\", ShippingTaxable, \"*\" from zip_to_tax where ZipCode in (" + zipCodesIn + ") and PrimaryRecord = 1"
    results = queryDatabase(@zipCode_query, ZIPCODE_DATABASE)
    results = results.strip.split('*')
    results.shift(6)
    @CustomerTaxRecords = Array.new
    begin
      city = results[0].strip
      state = results[1].strip
      county = results[2].strip
      #need to handle zipCodes with leading zeros - they trim that off in the Db
      results[3] = results[3].strip
      if results[3].length < 5
        begin
          results[3] = "0" + results[3]
        end while results[3].length < 5
      end
      zip = results[3].strip
      taxrate = results[4].strip.to_f
      shippingtaxable = results[5].strip
      custTaxRecord = CustomerTaxRecord.new(city, state, county, zip, taxrate, shippingtaxable)
      @CustomerTaxRecords.push(custTaxRecord)
      results.shift(6)
    end while results.size > 0



    return @CustomerTaxRecords
  end



end
end