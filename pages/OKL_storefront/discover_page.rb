
module Pages
  class DiscoverPage<BasePage
    include Sections
    set_url '/discover'
    section :header, LoggedInHeader, '.okl-header'
    element :title_label, '#discover-title'
    element :description_label, '#discover-description'
    element :sort_by_best_sellers_link, 'a[data-sortby=feature]'
    element :sort_by_price_link, 'a[data-sortby=price]'


    element :event_container, '#okl-event-carousel'
    element :see_all_sales_link, 'a', :text=>'See all sales'

    section :products, ProductContainer, '.standard'

  end
end