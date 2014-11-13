require 'mysql2'
require 'config'

okl_server = "#{ENV['OKL_SERVER']}"

MYSQL_OPTS = {:host => "king-#{okl_server}-db01.newokl.com",
             :port => "1%s030" % [okl_server[-1]],
             :username => "#{okl_server}",
             :password => "#{okl_server}"}

KING_CART_DB="king_cart"
KING_DB="king"
KING_VENDOR = "king_vendor"
IMP_DB="imp"

#
# Run a query on the database setup based on the okl_server in config.rb
#
# @param [String] query
# @param [String] database (Defaults to "king_cart")
#
# @return [Mysql2::Result] An object containing the results of the mysql2 query
#
# @raise Error on failure to connect
#
def run_query(query, database=KING_CART_DB)

  begin
    mysql2_client = Mysql2::Client.new(:host => MYSQL_OPTS[:host],
                                       :port => MYSQL_OPTS[:port],
                                       :username => MYSQL_OPTS[:username],
                                       :password => MYSQL_OPTS[:password],
                                       :database => database)

    $logger.Log "Executing query: '#{query}'"
    result = mysql2_client.query(query)
  rescue Mysql2::Error => e
    raise "#{__method__}(): Failed to connect to mysql server with options #{MYSQL_OPTS}: Error code: '#{e.errno}': #{e.error}'"
  ensure
    mysql2_client.close if mysql2_client
  end

  result
end
