module Hashblue
  class AccessToken
    def initialize(access_token)
      @access_token = access_token
    end

    def to_s
      @access_token
    end

    def valid?
      client.head '/account'
      true
    rescue Client::RequestError
      false
    end

    def refresh_with(client_identifier, client_secret, refresh_token)
      response = client.post '/oauth/access_token', {
        'grant_type' => 'refresh_token',
        'refresh_token' => refresh_token,
        'client_id' => client_identifier,
        'client_secret' => client_secret
      }, nil
      @access_token = response["access_token"]
      response
    end

    def client
      @client ||= Client.new(self)
    end
  end
end