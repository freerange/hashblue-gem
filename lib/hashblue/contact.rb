module Hashblue
  class Contact < Model
    attribute_methods :uri, :name, :phone_number, :msisdn, :email

    def messages(query = {})
      client.load_messages(messages_uri, query)
    end

    def messages_uri
      @attributes["messages"]
    end

    def send_message(content)
      client.post messages_uri, {}, "message" => {"content" => content}
    end
  end
end