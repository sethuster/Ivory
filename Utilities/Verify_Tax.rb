#CreatedBy: Seth Urban
# Purpose: A collection of functions to verify sales tax has been applied correctly
# to specific orders
#
# Used in Zip2Tax and Checkout Tests
module TaxObjects
class VerifyTax

  def percent_of(rate, total)
    return total.to_f / 100 * rate.to_f
  end

  def ExpectedTotal(shippingTaxable, subtotal, shippingTotal, taxRate)
    if shippingTaxable
      expectedTotal = subtotal.to_f + shippingTotal.to_f + percent_of(taxRate, subtotal + shippingTotal)
    else
      expectedTotal = (subtotal.to_f + percent_of(taxRate, subtotal)) + shippingTotal.to_f
    end

    return expectedTotal
  end

  def AppliedTax(shippingTaxable, subtotal, shippingTotal, taxTotal)
    if shippingTaxable
      appliedTaxRate = (taxTotal / (subtotal + shippingTotal)) * 100
    else
      appliedTaxRate = (taxTotal / subtotal) * 100
    end

    return appliedTaxRate
  end

end
end