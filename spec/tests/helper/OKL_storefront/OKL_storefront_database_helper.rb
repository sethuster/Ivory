require 'mysql_access'

def verify_order_in_ax(order_id)
  result = run_query("select * from order where order_id=#{order_id};", KING_CART_DB)
  if result.count != 1
    raise "Failed to verify order_id '#{order_id}' came through the AX"
  end

end

def lastNewUser(userPrefix)
  #should be passing in a constact from Test_data.rb
  #will be used to get the last new user created
  username = userPrefix + "%"
  query = "SELECT * FROM king.customer WHERE email LIKE %s" % "'" + username + "'"
  result = run_query(query, KING_DB)

  lastNewUser = result.count
  return lastNewUser
end

def updateQTY(product_url, qty)

  url_pieces = product_url.split("/")
  productid = url_pieces.last
  query = "select sku_id from king.product_to_sku where product_id = %s" % productid
  result = run_query(query, KING_DB)
  skuid = result.first['sku_id']


  #now that we have the SKU we need to do some math to figure out if we need to increase the quantity
  query = "select total_quantity, order_count from king_cart.inventory_reservable where sku_id = %s" % skuid
  resultset = run_query(query, KING_CART_DB)
  total_qty = resultset.first['total_quantity'].to_i
  order_count = resultset.first['order_count'].to_i
  if (total_qty - order_count) < 2
    updatedQTY = total_qty + qty
    query = "update king_cart.inventory_reservable set total_quantity = #{updatedQTY} where sku_id = #{skuid}"
    run_query(query, KING_CART_DB)
  end
end