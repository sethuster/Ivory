module Pages
  class MobileSearchResultsPage < SearchResultsPage
    ##
    # Select the first product found and return the Product page for it.
    #
    # @param [Symbol] product_type(optional): The type of product to find and click
    #
    # Currently supported product_type(s) - add more as you need them:
    #   :available (first product found that's not 'sold out' or 'on-hold')
    #   :available_vintage (first available vintage product)
    #   :sold_out (first sold-out product)
    #   :default (first product found in any product state)
    #
    def GoToFirstProduct(product_type=:default)

      wait_for_elements

      case product_type
        when :available_vintage
          first_product_vintage.click
        when :sold_out
          first_product_sold_out.click
        when :available
          first_product_not_sold_out_on_hold.click
        when :default
          first_product.click
      end

      MobileProductPage.new
    end

    def GoToResultsPage number
      pagination_container.click_link number

      MobileSearchResultsPage.new
    end

    def GoToNextResultsPage
      next_page_link.click

      MobileSearchResultsPage.new
    end

    def GoToPrevResultsPage
      prev_page_link.click

      MobileSearchResultsPage.new
    end
  end
end