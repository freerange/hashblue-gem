module Hashblue
  class Account < Model
    class << self
      def authenticate(access_token)
        client = Hashblue::Client.new(access_token)
        response = client.get("/account")
        Account.new(client, response["account"])
      end
    end

    attribute_methods :msisdn, :phone_number, :email

    def messages(query = {})
      client.load_messages(messages_uri, query)
    end

    def contacts(query = {})
      client.load_contacts(contacts_uri, query)
    end

    def favourite_messages(query = {})
      client.load_messages(favourite_messages_uri, query)
    end

    def messages_uri
      @attributes["messages"]
    end

    def contacts_uri
      @attributes["contacts"]
    end

    def favourite_messages_uri
      @attributes["favourite_messages"]
    end
  end
end