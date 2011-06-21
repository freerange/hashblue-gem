require 'httparty'

module Hashblue
  class Client
    class RequestError < StandardError; end

    include HTTParty

    base_uri "https://api.hashblue.com"

    attr_reader :access_token, :refresh_token

    def initialize(access_token, refresh_token = nil)
      @access_token = access_token
      @refresh_token = refresh_token
    end

    def account
      @account ||= Account.new(self, get("/account")["account"])
    end

    def messages(query = {})
      load_messages("/messages", query)
    end

    def favourites(query = {})
      load_messages("/messages/favourites", query)
    end

    def contacts(query = {})
      load_contacts("/contacts", query)
    end

    def load_messages(uri, query = {})
      Collection.new(self, Message, get(uri, query), "messages")
    end

    def load_contacts(uri, query = {})
      Collection.new(self, Contact, get(uri, query), "contacts")
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

    private

    def request(method, path, query, body = nil)
      response = self.class.send method, path, :query => query, :headers => request_headers
      case response.headers["status"]
      when "200" then response.to_hash
      else raise RequestError, "request unsuccessful: #{response.to_hash.inspect}"
      end
    end

    def request_headers
      {"Authorization" => "OAuth #{access_token}", 'Accept' => 'application/json'}
    end
  end
end