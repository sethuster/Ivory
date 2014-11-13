module Pages
  class ShopByVendorPage < BasePage
    element :vendor_name, :xpath, "//div[@class='hd']/h2"

    def VerifyVendorPageDisplayed(vendor_name)
      wait_until_vendor_name_visible

      if not self.vendor_name.text.eql?(vendor_name)
        raise "Failed to verify vendor page for '#{vendor_name}' is displayed"
      end

      self
    end
  end
end