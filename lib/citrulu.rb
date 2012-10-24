Dir[File.expand_path('../citrulu/*.rb', __FILE__)].each{|f| require f}
Dir[File.expand_path('../faraday/*.rb', __FILE__)].each{|f| require f}
require 'faraday'

module Citrulu
  BASE_URL = "https://www.citrulu.com/api/v1"
  # BASE_URL = "http://localhost:3000/api/v1"
  
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