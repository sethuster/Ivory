require 'base_section'

module Sections
  class ProductContainer<BaseSection
    element :product_image, '.productImage'
    element :product_title_link, 'h3>a'
    element :retail_price_label, '.msrp'
    element :our_price_label, :xpath,  '//ul/li[2]'
    element :sale_end_container, '.product-date'
  end
end
