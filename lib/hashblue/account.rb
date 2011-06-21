module Hashblue
  class Account < Model
    attribute_methods :msisdn, :phone_number, :email

    def messages(query = {})
      client.load_messages(messages_uri, query)
    end

    def contacts(query = {})
      client.load_contacts(contacts_uri, query)
    end

    def messages_uri
      @attributes["messages"]
    end

    def contacts_uri
      @attributes["contacts"]
    end
  end
end