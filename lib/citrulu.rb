BASE_URL = "https://www.citrulu.com/api"
API_VERSION = "v1"

# Helper methods to write:
# .prepend, .append - TDD THEM!!!

require File.expand_path('../citrulu/test_file', __FILE__)
require 'faraday'

module API
  def self.connection
    Faraday.new(:url => "#{BASE_URL}/#{API_VERSION}") do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end
  end
end