module Hashblue
  class Contact < Model
    attribute_methods :name, :phone_number, :msisdn, :email

    def messages(query = {})
      client.load_messages(messages_uri, query)
    end

    def messages_uri
      @attributes["messages"]
    end
  end
end