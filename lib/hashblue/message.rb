module Hashblue
  class Message < Model
    attribute_methods :uri, :timestamp, :content

    def contact
      @contact ||= Contact.new(client, @attributes["contact"])
    end

    def sent?
      @attributes["sent"]
    end

    def favourite?
      @attributes["favourite"]
    end

    def delete!
      client.delete(uri)
    end

    def favourite!
      client.put(uri + '/favourite', {}, {})
      @attributes['favourite'] = true
      true
    end

    def unfavourite!
      client.delete(uri + '/favourite')
      @attributes['favourite'] = false
      true
    end
  end
end