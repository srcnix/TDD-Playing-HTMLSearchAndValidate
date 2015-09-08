module SearchEngines
  class Google < Base
    def get_links_for(query)
      links   = []
      page    = self.search(query)

      page.search('div.g h3.r a').each do |link|
        links << Mechanize::Page::Link.new(link, self.agent, page)
      end

      links
    end

    def search(query)
      page          = self.agent.get('https://www.google.com')
      form          = page.form
      search_field  = form.field_with(name: 'q')
      search_button = form.button_with(name: 'btnG')

      search_field.value = query
      form.submit
    end
  end
end
