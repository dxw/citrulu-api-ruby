# Adapted from the Instagram ruby gem: 
# https://github.com/Instagram/instagram-ruby-gem/blob/master/lib/faraday/raise_http_exception.rb

require 'faraday'

module FaradayMiddleware
  class RaiseHttpException < Faraday::Middleware
    # Handle response codes 401, 404 and 500 as exceptions. See https://github.com/technoweenie/faraday#writing-middleware for more details.
    def call(env)
      @app.call(env).on_complete do |response|
        case response[:status].to_i
        when 401
          raise Citrulu::AccessDenied, error_message_400(response)
        when 404
          raise Citrulu::NotFound, error_message_400(response)
        when 500
          raise Citrulu::InternalServerError, error_message_500(response, "Something is technically wrong.")
        end
      end
    end

    private
        
    def error_message_400(response)
      "#{response[:method].to_s.upcase} #{response[:url].to_s}: #{response[:status]}#{error_body(response[:body])}"
    end

    def error_body(body)
      # body gets passed as a string, not sure if it is passed as something else from other spots?
      if not body.nil? and not body.empty? and body.kind_of?(String)
        body = ::JSON.parse(body)
      end

      if body.nil?
        nil
      elsif body['meta'] and body['meta']['error_message'] and not body['meta']['error_message'].empty?
        ": #{body['meta']['error_message']}"
      end
    end

    def error_message_500(response, body=nil)
      "#{response[:method].to_s.upcase} #{response[:url].to_s}: #{[response[:status].to_s + ':', body].compact.join(' ')}"
    end
  end
end