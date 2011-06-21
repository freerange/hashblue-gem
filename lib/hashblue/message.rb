module Hashblue
  class Message < Model
    attribute_methods :uri, :timestamp, :content

    def sent?
      @attributes["sent"]
    end

    def favourite?
      @attributes["favourite"]
    end

    def contact
      @contact ||= Contact.new(client, @attributes["contact"])
    end
  end
end