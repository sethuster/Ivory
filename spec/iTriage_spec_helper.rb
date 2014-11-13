$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'pages/iTriage'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'sections/iTriage'))


require 'spec_helper'
require_all 'sections/iTriage'
include Sections

require_all 'pages/iTriage'
include Pages


