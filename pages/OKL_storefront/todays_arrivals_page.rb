module Sections
  class VMFCarouselSection < BaseSection

    # back/fwd arrows
    element :back_arrow, 'a.back'
    element :fwd_arrow, 'a.forward'

    # carousel item container
    element :item_container, 'div.carousel-container ul'
  end
end

# Vintage Market Finds
module Pages
  class TodaysArrivalsPage < BasePage
    attr_reader :header
    set_url '/vintage-market-finds/todaysarrivals'

    element :first_product_link, "li.product.sortable a"

    section :header, LoggedInHeader, '.okl-header'
    section :vmf_carousel_section, VMFCarouselSection, '#okl-vmf-category-carousel-hd'


    def GoToFirstProduct
      first_product_link.click

      ProductPage.new
    end

    def MoveCarouselForward
      vmf_carousel_section.fwd_arrow.click
      sleep 1

      self
    end

    def MoveCarouselBack
      vmf_carousel_section.back_arrow.click
      sleep 1

      self
    end

    ##
    # Verify the carousel position based on evaluating the margin-left style attribute
    #
    # @param [Symbol] section The :first, :second, or :third section of the carousel
    #
    def VerifyCarouselPosition(section)
      section_margins = ["",
                         "margin-left: -720px;",
                         "margin-left: -850px;"]
      case section
        when :first
          if not vmf_carousel_section.item_container[:style].eql?(section_margins[0])
            raise "Failed to verify the first carousel section displayed"
          end
        when :second
          if not vmf_carousel_section.item_container[:style].eql?(section_margins[1])
            raise "Failed to verify the second carousel section displayed"
          end
        when :third
          if not vmf_carousel_section.item_container[:style].eql?(section_margins[2])
            raise "Failed to verify the third carousel section displayed"
          end
        else
          raise "#{__method__}(): Invalid carousel section parameter"
      end

      self
    end
  end
end
