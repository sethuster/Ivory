$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'pages/OKL_storefront'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'sections/OKL_storefront'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'tests/helper/OKL_storefront'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'Utilities'))

require 'spec_helper'
require_all 'sections/OKL_storefront'
include Sections

require_all 'pages/OKL_storefront'
require_all 'pages/OKL_storefront/PageSplitters'
include Pages

require_all 'Utilities'

require 'OKL_storefront_database_helper'
require 'tests/OKL_storefront/storefront_test_data'
