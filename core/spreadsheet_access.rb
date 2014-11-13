module SpreadSheetAccess
  require 'roo'
  require 'spreadsheet'

  #
  # Parse the excel file for the okl sku and return a hash containing its details
  #
  # @param [String] filepath: path to the excel file
  # @param [String] okl_sku
  #
  # @return [Hash] Containing the okl sku details from the spreadsheet
  #
  def get_sku_details_from_association_reupload(filepath, okl_sku)
    begin
      xls_file = Roo::Spreadsheet.open(filepath, :extension => :xls)

      # strip out whitepsace and unicode chars
      xls_file.parse(:clean => true)

      # Array of hashes for all of the row data
      xls_rows = xls_file.parse(:header_search=>['Okl SKu #'])

      # find the row containing the okl_sku
      sku_rows_array = xls_rows.select { |hash| hash['Okl Sku #'].eql?(okl_sku) }

      raise "#{__method__}(): Failed to find row in excel file containing #{okl_sku}" if sku_rows_array.empty?

      sku_hash = sku_rows_array[0]

      # rename those hash keys to something easier to use
      mappings = {
          "Okl Sku #" => :okl_sku,
          "Product Name" => :product_name,
          "Vr (edit)" => :vendor_edit,
          "Vr (last Set)" => :vendor_last_set,
          "Vr (current Ats)" => :vendor_ats,
          "Owned (edit)" => :owned_edit,
          "Owned (last Set)" => :owned_last_set,
          "Owned (current Ats)" => :owned_ats,
          "Has Commitment" => :has_commitment,
          "Ats" => :ats,
          "Orders In Process" => :orders_in_process,
          "Okl Units" => :okl_units
      }

      Hash[ sku_hash.map {|k,v| [mappings[k], v] if mappings.has_key?(k)} ]
    rescue Exception => e
      raise "#{__method__}(): Failed to get sku details from excel spreadsheet '#{filepath}': #{e.message}"
    end
  end
end