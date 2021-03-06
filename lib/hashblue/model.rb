module Hashblue
  class Model
    attr_accessor :client

    def initialize(attributes)
      @client = client
      @attributes = attributes
    end

    def attributes
      @attributes.dup
    end

    def eql?(m)
      m.is_a?(self.class) && m.attributes.eql?(attributes)
    end

    class << self
      def build(client, attributes = {})
        new(attributes).tap {|m| m.client = client}
      end

      def attribute_methods(*names)
        names.each do |name|
          define_method(name) do
            @attributes[name.to_s]
          end
        end
      end
    end
  end
end