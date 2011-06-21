module Hashblue
  class Message < Model
    attribute_methods :uri, :timestamp, :content

    def contact
      @contact ||= Contact.new(client, @attributes["contact"])
    end

    def delete!
      client.delete(uri)
    end
  end
end