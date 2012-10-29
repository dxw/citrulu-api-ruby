Dir[File.expand_path('../citrulu/*.rb', __FILE__)].each{|f| require f}
Dir[File.expand_path('../faraday/*.rb', __FILE__)].each{|f| require f}
require 'faraday'

module Citrulu
  # The address of the Citrulu API
  BASE_URL = "https://www.citrulu.com/api/v1"
  
  # Sets up the connection to the Citrulu API using the api key, which must already have been set to CITRULU_API_KEY
  def self.connection
    Faraday.new(:url => BASE_URL) do |connection|
      connection.request  :url_encoded             # form-encode POST params
      connection.response :logger                  # log requests to STDOUT
      connection.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      connection.use      FaradayMiddleware::RaiseHttpException
      
      connection.params[:auth_token] = CITRULU_API_KEY # Authenticate using the user's API key
    end
  end
end