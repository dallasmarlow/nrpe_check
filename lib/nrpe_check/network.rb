require 'net/http'
require 'net/https'
require 'timeout'
require 'uri'


module NRPE
  module Network
    include NRPE::Logging

    # Retrieves a URL via GET or POST, passes args as query parameters (during
    # GET) or form parameters (during POST).  Returns response body and
    # response code if successful; otherwise, returns default and nil.
    #
    # @param [String] address URL to query.
    # @param [Symbol] method HTTP method to use (:get or :post).
    # @param [Hash] args GET query params or POST form parameters.
    # @param [String] username username for HTTP Basic authentication.
    # @param [String] password password for HTTP Basic authentication.
    # @param [String] default default return value in error case.
    # @param [Integer] timeout timeout for HTTP call.
    # @return response.body, response.code if successful, otherwise default, nil
    def call_url address, method = :get, args = {}, username = "", password = "", default = "", timeout = 30
      begin
        uri = URI.parse address
        http = Net::HTTP.new uri.host, uri.port
        # See http://notetoself.vrensk.com/2008/09/verified-https-in-ruby/.
        if uri.is_a? URI::HTTPS
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        end
        # Creates an HTTP query based upon the type of method provided.
        case method
        when :get
          uri.query = URI.encode_www_form args.reduce([]) { |k, v| k << v }
          request = Net::HTTP::Get.new uri.request_uri
        when :post
          request = Net::HTTP::Post.new uri.request_uri
          request.set_form_data args
        else
          log_failure "HTTP method #{method} not supported :`("
          return default
        end
        # Applies HTTP Basic authentication to request if desired by user.
        unless [username, password].all? &:empty?
          request.basic_auth username, password
        end
        # Obtains HTTP response, bounded within user-supplied timeout.
        response = Timeout::timeout(timeout) do
          http.request request
        end
        if not response.is_a? Net::HTTPSuccess
          log_failure "Non-200 response code after #{method}: #{address}, #{args}"
          log_failure "Code: #{response.code}, Body:\n#{response.body}"
        end
        return response.body, response.code
      rescue Timeout::Error
        log_failure "Timeout reached during HTTP #{method} to #{address}, #{args}"
        return default, nil
      # See https://gist.github.com/245188
      rescue StandardError => e
        log_failure "Error during HTTP #{method} to #{address}, #{args}: #{e}"
        return default, nil
      end
    end # def call_url

  end # module Network
end # module NRPE
