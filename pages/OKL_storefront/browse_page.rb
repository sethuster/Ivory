
module Pages
  class BrowsePage<BasePage
    include Sections
    element :title_label, '.title'
    element :description_label, '.description'
    sections :products, ProductContainer, '.product'

    def wait_for_elements
      wait_until_title_label_visible
      wait_until_description_label_visible
      wait_for_products
    end
  end
end
