#CreatedBy: Seth Urban
# Purpose: Stores customer information to be used for tax rate analysis.  Individual Records are stored in Customer_tax_record
#
# Used in Zip2Tax and Checkout Tests
module TaxObjects
class CustomerTaxRecord
  #starting Information
  @cust_city #string
  @cust_stateAbbr #string
  @cust_state #string
  @cust_county #string
  @cust_zipcode #int
  @cust_salesTaxRate #float
  @cust_shippingTaxable #bool
  @cust_basicinfo = Hash.new

  #After order information
  @cust_fname #string
  @cust_lname #string
  @cust_confNumber #string
  @cust_appliedTax #float
  @cust_orderTotal #float
  @cust_email #string
  @cust_orderInfo = Hash.new

  def initialize(city, stateAbbr, county, zipcode, salestax, shipping)
    @cust_city = city
    @cust_stateAbbr = stateAbbr
    @cust_county = county
    @cust_zipcode = zipcode
    @cust_salesTaxRate = salestax
    @cust_shippingTaxable = shipping

    #push the stuff into an array for checking values
    @cust_basicinfo = {
        :City => @cust_city,
        :State => @cust_stateAbbr,
        :County => @cust_stateAbbr,
        :ZipCode => @cust_zipcode,
        :TaxRate => @cust_salesTaxRate,
        :TaxShipping => @cust_shippingTaxable
    }

  end

  def AddOrderInfo(fname, lname, email, confirmationNumber, appliedTax, orderTotal)
    @cust_fname = fname
    @cust_lname = lname
    @cust_email = email
    @cust_confNumber = confirmationNumber
    @cust_appliedTax = appliedTax
    @cust_orderTotal = orderTotal

    @cust_orderInfo = {
        :FirstName => @cust_fname,
        :LastName => @cust_lname,
        :Email => @cust_email,
        :ConfirmationNumber => @cust_confNumber,
        :AppliedTax => @cust_appliedTax,
        :OrderTotal => @cust_orderTotal
    }
  end

  def GetCity
    return @cust_city
  end

  def GetState
    case @cust_stateAbbr
      when "AL"
        @cust_state = "Alabama"
      when "AK"
        @cust_state = "Alaska"
      when "AZ"
        @cust_state = "Arizona"
      when "AR"
        @cust_state = "Arkansas"
      when "CA"
        @cust_state = "California"
      when "CO"
        @cust_state = "Colorado"
      when "CT"
        @cust_state = "Connecticut"
      when "DE"
        @cust_state = "Delaware"
      when "DC"
        @cust_state = "District of Columbia"
      when "FL"
        @cust_state = "Florida"
      when "GA"
        @cust_state = "Georgia"
      when "HI"
        @cust_state = "Hawaii"
      when "ID"
        @cust_state = "Idaho"
      when "IL"
        @cust_state = "Illinois"
      when "IN"
        @cust_state = "Indiana"
      when "IA"
        @cust_state = "Iowa"
      when "KS"
        @cust_state = "Kansas"
      when "KY"
        @cust_state = "Kentucky"
      when "LA"
        @cust_state = "Louisiana"
      when "ME"
        @cust_state = "Maine"
      when "MD"
        @cust_state = "Maryland"
      when "MA"
        @cust_state = "Massachusetts"
      when "MI"
        @cust_state = "Michigan"
      when "MN"
        @cust_state = "Minnesota"
      when "MS"
        @cust_state = "Mississippi"
      when "MO"
        @cust_state = "Missouri"
      when "MT"
        @cust_state = "Montana"
      when "NE"
        @cust_state = "Nebraska"
      when "NV"
        @cust_state = "Nevada"
      when "NH"
        @cust_state = "New Hampshire"
      when "NJ"
        @cust_state = "New Jersey"
      when "NM"
        @cust_state = "New Mexico"
      when "NY"
        @cust_state = "New York"
      when "NC"
        @cust_state = "North Carolina"
      when "ND"
        @cust_state = "North Dakota"
      when "OH"
        @cust_state = "Ohio"
      when "OK"
        @cust_state = "Oklahoma"
      when "PA"
        @cust_state = "Pennsylvania"
      when "RI"
        @cust_state = "Rhode Island"
      when "SC"
        @cust_state = "South Carolina"
      when "SD"
        @cust_state = "South Dakota"
      when "TN"
        @cust_state = "Tennessee"
      when "TX"
        @cust_state = "Texas"
      when "UT"
        @cust_state = "Utah"
      when "VT"
        @cust_state = "Vermont"
      when "VA"
        @cust_state = "Virginia"
      when "WA"
        @cust_state = "Washington"
      when "WV"
        @cust_state = "West Virginia"
      when "WI"
        @cust_state = "Wisconsin"
      when "WY"
        @cust_state = "Wyoming"
      else
        @cust_state = "State Not found - Customer_tax_record"
    end
    return @cust_state
  end

  def GetStateAbbr
    return @cust_stateAbbr
  end

  def GetZip
    return @cust_zipcode
  end

  def GetTaxRate
    return @cust_salesTaxRate
  end

  def GetShippingTaxable
    if @cust_shippingTaxable.equal?(1)
      taxable = true
    else
      taxable = false
    end
    return taxable
  end

  def AllFieldsPopulated
    if @cust_basicinfo.value?(nil) || @cust_orderInfo.value?(nil)
      populated = false
    else
      populated = true
    end
    return populated
  end

end
end