class SearchLinks
  attr_reader :search_engine

  def initialize(search_engine: 'Google')
    self.search_engine = search_engine
  end

  def get_first_link_content_for(query)
    link = self.get_first_link_for(query)

    self.get_content_for_link(link)
  end

  def get_content_for_link(link)
    self.search_engine.get_content_for_link(link)
  end

  def get_first_link_for(link)
    self.get_links_for(link).first
  end

  def get_links_for(query)
    self.search_engine.get_links_for(query)
  end

  def search_engine=(engine)
    search_engine_class_str = "SearchEngines::#{engine}"

    unless Class.const_defined?(search_engine_class_str)
      raise SearchLinks::Exception, "#{search_engine_class_str} undefined"
    end

    @search_engine = Class.const_get(
      search_engine_class_str
    ).new
  end

  class Exception < ::Exception; end
end
