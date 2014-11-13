module Sections
  class BaseSection<SitePrism::Section
    def initialize parent, root_element
      super
      wait_for_elements
    end

    def wait_for_elements
    end
  end
end
