class Hashblue::Collection
  def initialize(client, model_class, data, name)
    @client = client
    @model_class = model_class
    @data = data
    @name = name
    @items = @data[name].collect do |item|
      model_class.build(client, item)
    end
  end

  def respond_to?(method)
    super || @items.respond_to?(method)
  end

  def method_missing(method, *args, &block)
    @items.respond_to?(method) ? @items.send(method, *args, &block) : super
  end

  def next_page?
    !!@data["next_page_uri"]
  end

  def next_page
    if next_page?
      self.class.new(@client, @model_class, @client.get(@data["next_page_uri"]), @name)
    else
      nil
    end
  end

  def previous_page?
    !!@data["previous_page_uri"]
  end

  def previous_page
    if previous_page?
      self.class.new(@client, @model_class, @client.get(@data["previous_page_uri"]), @name)
    else
      nil
    end
  end

  def each_page(&block)
    yield self if block_given?
    next_page.each_page(&block) if next_page?
  end
end