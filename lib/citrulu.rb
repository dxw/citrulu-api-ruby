require File.expand_path('../citrulu/test_file', __FILE__)
require 'faraday'

module Citrulu
  BASE_URL = "https://www.citrulu.com/api/v1"
  
  def self.connection
    Faraday.new(:url => BASE_URL) do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.params =      { 'auth_token' => CITRULU_API_KEY }
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end
  end
end