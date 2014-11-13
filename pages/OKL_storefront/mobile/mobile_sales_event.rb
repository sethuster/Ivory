module Pages
  class MobileSalesEvent < SitePrism::Page

    set_url "/sales{/sale}"

    element :sort_options_select, '#product-sort'
    elements :products, :xpath, "//li[contains(@id,'product-tile')]"
    elements :products_sold_out, :xpath, "//li[contains(@id,'product-tile') and contains(@class,'sold')]"
    elements :products_vintage, :xpath, "//li[contains(@id,'product-tile') and contains(@class,'vintage')]"
    elements :prices, :xpath, "//*[contains(@class,'okl-price') and not (../../../../../li[contains(@class,'sold')])]"
    section :header, MobileHeader, '.page-header'
    section :footer, MobileFooter, '.page-footer'

    def SortItems(sort_type)
      wait_for_sort_options_select

      case sort_type
        when :featured then sort_options_select.select("Featured")
        when :low_price then sort_options_select.select("Lowest Price")
        when :available then sort_options_select.select("Available")
        else
          raise "#{__method__}(): Invalid sort_type parameter"
      end

      self
    end

    def VerifyPriceListSortedByLowestPrice
      price_list = prices.map { |price| string_to_price(price.text) }
      price_list.each_with_index do |price, index|
        next if index.eql?(price_list.size - 1)

        raise "Price list is not sorted properly: #{price_list}" if price > price_list[index+1]
      end
    end

    private

    def string_to_price(str)
      /\$([\d,]+)/.match(str)[1].gsub(',', '').to_i
    end
  end
end