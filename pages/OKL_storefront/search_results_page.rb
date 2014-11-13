require 'site_prism'

module Pages
  class SearchResultsPage < BasePage
  element :query_phrase, '.query_phrase'
  element :search_results_summary, '.search-results-summary'
  element :sort_dropdown, '.sort-dropdown'
  element :sort_option_relevance, '.sort-featured'
  element :sort_option_lowest_price, '.sort-price_low'
  element :sort_option_highest_price, '.sort-price_high'
  element :category_filter, '.category-filter'
  element :color_filter, '.color-filter'
  element :price_filter, '.price-filter'
  element :condition_filter, '.condition-filter'
  element :first_product, '.productImage'
  element :first_product_sold_out, :xpath, "//a[@class='trackProductPlacement' and ./div[contains(@class, 'sold-out')]]"
  element :first_product_not_sold_out_on_hold, :xpath, "//a[@class='trackProductPlacement' and not(./div[contains(@class, 'sold-out')] or ./div[contains(@class, 'on-hold')])]"
  element :first_product_vintage, :xpath, "//a[@class='trackProductPlacement' and ./span[contains(@class, 'vintage')] and not(./div[contains(@class, 'sold-out')] or ./div[contains(@class, 'on-hold')])]"
  element :pagination_container, '.pagination'
  elements :pages_links, '.pagination a'
  element :next_page_link, '.nextPage'
  element :prev_page_link, '.prevPage'
  element :no_results_found, '.search_heading'
  element :color_swatch, '.color-swatch'
  element :back_to_top_button, '.backToTop'
  set_url "/search{q=?query*}"

    def wait_for_elements
      wait_until_first_product_visible

      # for IOS need to wait for page to load as much as it can, specially for 'sold out' tag
      if IOS
        find(:xpath, "//div[contains(@class, 'sold-out')]")
      end
      self
    end

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

      #ProductPage.new
      PDPSplitter.new.CheckPDP
    end

    def GetNumPaginationLinks
      # do not count next link
      pages_links.size - 1
    end

    def GoToResultsPage number
      pagination_container.click_link number
      SearchResultsPage.new
    end

    def GoToNextResultsPage
      next_page_link.click
      SearchResultsPage.new
    end

    def GoToPrevResultsPage
      prev_page_link.click
      SearchResultsPage.new
    end

    def SelectColor color
      color_filter.find("li[title=#{color}]").click
      self
    end

    def SelectCategory name
      category_filter.click_link name
      self
    end

    def SelectPrice values
      price_filter.find("li.price-#{values}>input").click
      self
    end

    def SelectCondition text
      condition_filter.find("li.condition-#{text}>input").click
      self
    end

    def GoBackToTop
      back_to_top_button.click
    end

  end
end
