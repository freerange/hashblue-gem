require 'httparty'
require 'active_support/ordered_hash'
require 'active_support/json'

module Hashblue
  class Client
    class RequestError < StandardError; end

    include HTTParty

    base_uri "https://api.hashblue.com"
    headers 'Accept' => 'application/json',
            'User-Agent' => "Hashblue Client Gem v#{Hashblue::VERSION} (https://github.com/freerange/hashblue-gem)"

    attr_reader :access_token

    def initialize(access_token)
      @access_token = access_token
    end

    def load_messages(uri, query = {})
      Collection.new(self, Message, get(uri, query), "messages")
    end

    def load_contacts(uri, query = {})
      Collection.new(self, Contact, get(uri, query), "contacts")
    end

    def head(path, query = {})
      request :head, path, query
    end

    def get(path, query = {})
      request :get, path, query
    end

    def delete(path, query = {})
      request :delete, path, query
    end

    def put(path, query, body)
      request :put, path, query, body
    end

    def post(path, query, body)
      request :post, path, query, body
    end

    private

    def request(method, path, query, body = nil)
      options = {:query => query, :headers => self.class.headers.merge(authorization_header)}
      if body
        options[:headers]["Content-type"] = "application/json"
        options[:body] = ActiveSupport::JSON.encode(body)
      end

      response = self.class.send method, path, options
      case response.code
      when 200, 201 then response.to_hash
      else raise RequestError, "request unsuccessful: #{response.inspect}"
      end
    end

    def authorization_header
      {
        "Authorization" => "OAuth #{access_token}",
      }
    end
  end
end