module Pages
  class SalesEvent < SitePrism::Page

    attr_reader :products

    set_url "/sales{/sale}"

    element :sort_by, 'section.chapters > .sort-filters em'
    elements :sort_options, 'section.chapters > .sort-filters a'
    elements :products, 'li.product'
    elements :prices, '.price em'
    section :header, LoggedInHeader, '.okl-header'
    section :footer, LoggedInFooter, '#footer'


    @@sort_type = [:featured, :low_price, :available]

    def wait_for_elements
      wait_until_products_visible(10)

      self
    end

    #
    # Verify the list of product ids are displayed in the sales event
    #
    # @param [Array] product_ids
    #
    # @return [SalesEvent] self
    #
    # @raise [RunTimeError] if the list of product IDs are not found in the sales event
    #
    def VerifyProductIDsDisplayed(product_ids)
      errors = Array.new
      product_ids.each do |id|
        product_css = "li.product[data-product-id='#{id}']"
        begin
          find_first(product_css)
        rescue
          errors << "Failed to find product_id '#{id}' in the OKL_storefront sales event"
        end
      end

      if !errors.empty?
        raise "#{__method__}(): [#{errors.join("  |  ")}]"
      end

      self
    end

    def SortItems(sort_type_i)
      list_index = @@sort_type.index(sort_type_i)
      wait_for_sort_by
      sort_by.click
      wait_for_sort_options
      sort_options[list_index].click
    end
  end

  def PriceList
    prices.map { |price| string_to_price(price.text) }
  end

  private
  def string_to_price(str)
    /\$([\d,]+)/.match(str)[1].gsub(',', '').to_i
  end

end